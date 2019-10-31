Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4897EBA17
	for <lists+stable@lfdr.de>; Thu, 31 Oct 2019 23:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728207AbfJaW44 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Oct 2019 18:56:56 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:46225 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726680AbfJaW44 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Oct 2019 18:56:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572562613;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=hsazX/2cdvsd2UrhLyRGFR2m9XT3QtbL6U2YX0qY3fM=;
        b=disZyg79oKSKAbvzEFhtktCkFzoYXPaIyBBtMI5YlpiUVC6e/0mZMVeDX4EwM0fNvtDD2D
        RSDknEMi5ylDALJeb+nxvaak4+elXaV/49c2yAR0gQRRYMfBQjSd2brxcn2FQm6h4emFjY
        dhRhtSOTweZW5MxBdcejVR1vF0mWCao=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-26-ier4xrGpNnSXVmlKOcNCBg-1; Thu, 31 Oct 2019 18:56:51 -0400
Received: by mail-wr1-f70.google.com with SMTP id 4so4384865wrf.19
        for <stable@vger.kernel.org>; Thu, 31 Oct 2019 15:56:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XLka1Wegs5Poy1s6KcdsjNpn4BlCfTOrvfQWXEfo7jw=;
        b=ry2KCfLCA9q3mgyfb9n680LrD9qWsxH9MrXsWfqnL1P8n8R/J+AsOwdEpHbb6kw7EY
         /sHHJX79MiLIU6r01zrV/bsHSgK+aF7EKAokmdOAY26hrKr7e0N/5KpADubTusgARvW2
         68uZzCHhQhtV691xVSK/fOIOJb4D8P9e8vO21Ze5DJ32VthDGQyOgEKJ+CutX6po9C2M
         Z8fRFhDRv4hOrkw2t+KDFah1fm/afrsTYbKGuGSgbucG9Sq6IlRah1ATYIlCwfFHM/OE
         HDs1W+d3pyQ+SAO3fwv9sM0Z0I7ijgCITUpg1jyl+RfPnHUcVSizO2UpJS9FvAeodOkf
         ZHeg==
X-Gm-Message-State: APjAAAX9iqTQ5/v+qJcbv1srqG5SoWxJ/S/FQxZDaE2BZd1eg4nGIwFE
        k+ZKlUq9HcQtrrfRBtQWhkJXFrt5IFd7Bc455ExJFy7zg4mK2Q7zZaitMQJxX2B9BhaELFmheYb
        XLhedSZQ+JG0fMbRS
X-Received: by 2002:adf:db0d:: with SMTP id s13mr7666998wri.319.1572562610334;
        Thu, 31 Oct 2019 15:56:50 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzv6DS9Kcssbe/HxbCJzzfTDCkzm4UhsJt0D6LeXtynHPukfhwlCvibJv4SH0s9VZ2rReHldA==
X-Received: by 2002:adf:db0d:: with SMTP id s13mr7666976wri.319.1572562610034;
        Thu, 31 Oct 2019 15:56:50 -0700 (PDT)
Received: from [192.168.20.72] (94.222.26.109.rev.sfr.net. [109.26.222.94])
        by smtp.gmail.com with ESMTPSA id w17sm5812390wra.34.2019.10.31.15.56.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Oct 2019 15:56:49 -0700 (PDT)
Subject: Re: [PATCH 3.16 47/47] KVM: x86/vPMU: refine kvm_pmu err msg when
 event creation failed
To:     Joe Perches <joe@perches.com>, Ben Hutchings <ben@decadent.org.uk>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        Like Xu <like.xu@linux.intel.com>
References: <lsq.1572026582.631294584@decadent.org.uk>
 <220d8f2c1b299d2e71fdcf50b98286aae5b0c6f2.camel@perches.com>
 <05be6a70382f1990a2ba6aba9ac75dac0c55f7fb.camel@decadent.org.uk>
 <3078d0a186cca2dfae741908ffff41f1bdb30eae.camel@perches.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <35a63ec6-234b-3dda-fbbc-df344e97e468@redhat.com>
Date:   Thu, 31 Oct 2019 23:56:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <3078d0a186cca2dfae741908ffff41f1bdb30eae.camel@perches.com>
Content-Language: en-US
X-MC-Unique: ier4xrGpNnSXVmlKOcNCBg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 31/10/19 23:53, Joe Perches wrote:
> I think not, but hey, maybe you and Greg do.
>=20
> Porting enhancements, even trivial ones, imo is
> not a great thing for stable branches.
>=20
> My perspective is that only bug fixes should be
> applied to stable branches.
>=20
> cheers, Joe

I agree this is borderline.  The main reason why I applied is that I get
occasional bug reports about it even from experienced Linux developers,
probably because the printk_once hides the message on systems that have
been up for a while.

Paolo

