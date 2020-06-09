Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 870CA1F3E83
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 16:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729130AbgFIOp1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 10:45:27 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:58445 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726395AbgFIOp1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 10:45:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591713925;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D0N8IG0w6TqyvrPZq3Bf6WEEBOpAcUrPcq971x3xCR0=;
        b=YJ5hZqfIra5z12yIBFMzSoripGfL2g3X52X118G6t2zNX5CSpGxTkcxiQEP55K9xNItp02
        8GA/yNGg+Mg4TkuP0oMIhUopl5TyWXHOOactm9yuY4mfz2qpycycpToFKsSaPtVljjTCBi
        wscudhgnIWFTlvg/v3DEe6mWf0DLElg=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-122-DVxVQt9rOd6iYjDmpXh96Q-1; Tue, 09 Jun 2020 10:45:23 -0400
X-MC-Unique: DVxVQt9rOd6iYjDmpXh96Q-1
Received: by mail-qv1-f71.google.com with SMTP id j4so16858132qvt.20
        for <stable@vger.kernel.org>; Tue, 09 Jun 2020 07:45:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=D0N8IG0w6TqyvrPZq3Bf6WEEBOpAcUrPcq971x3xCR0=;
        b=tAxQPIql5/M4b6bv0Lp/ToYnHCepokTeaWgmDBQykCCKVLdA8i2eRrpub0JXJt+npq
         JJrMTUZGb8pDgDMAKG1ZcLZNWkEm0qQOYMXbw8x/jPpl9AD2TSzDOOOVOWS5/lhAhiHj
         cMn/s2tZXZ7gwHyWMkZ1dLpWoCPTMoHWN5M+nK5RFuRm15rAQHsaRc8NlS4NCKe4qpHf
         kjgTihe2/bYvMvGImCL13wTMP3+3ZCd1txFKjXEXqzWQUdGxaxVx3oR8v+75NFf82CgM
         pip5PNFEOzXEZDJ1JI39Q9vDVdCMfpxKY33uScLcdCmFKTS8x250guV5Xoun4ptsoDAu
         jjGA==
X-Gm-Message-State: AOAM5306YK7g1Sc9f9vGercuN6bY48rz7FNxwVxvquWVeFJeeZlEkz+9
        FkYTVurBjdG8wsZEo+7BYpeF9pBlkZB+jpGSd8cNOA4AlTch9XxwIr4lnnWUWL7RgWi7i8idiqC
        I1BxWwh+PriEeJqQm
X-Received: by 2002:a37:7645:: with SMTP id r66mr27146846qkc.397.1591713921604;
        Tue, 09 Jun 2020 07:45:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxrDWGGcedgDp0WJSfkST6HxfilfGNNkZ2qb1/AuAvSqBZwRXvtCKZT5td9mD5UlkwPlyTrdg==
X-Received: by 2002:a37:7645:: with SMTP id r66mr27146798qkc.397.1591713921109;
        Tue, 09 Jun 2020 07:45:21 -0700 (PDT)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id f43sm11650042qte.58.2020.06.09.07.45.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jun 2020 07:45:20 -0700 (PDT)
Subject: Re: [PATCH 1/1] selftests: fpga: dfl: A test for afu interrupt
 support
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>, linux-fpga@vger.kernel.org,
        shuah@kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
References: <20200609130208.27390-1-trix@redhat.com>
 <20200609130208.27390-2-trix@redhat.com> <20200609142007.GA831428@kroah.com>
From:   Tom Rix <trix@redhat.com>
Message-ID: <d3d8e518-0760-8cbe-cf74-191f70329a46@redhat.com>
Date:   Tue, 9 Jun 2020 07:45:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200609142007.GA831428@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> Why not use the ksft_* functions and frameworks to properly print out
> the test status and results so that tools can correctly parse it?
>
> It's generally bad-form to make up your own format.

I used the the drivers/dma-buf test a basis example.  Can you point me at a better example ?

T

> thanks,
>
> gre gk-h
>

