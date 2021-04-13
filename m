Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE1635DC8B
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 12:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243421AbhDMKiK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 06:38:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243916AbhDMKiF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Apr 2021 06:38:05 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22A19C061574;
        Tue, 13 Apr 2021 03:37:45 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id x7so15898617wrw.10;
        Tue, 13 Apr 2021 03:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VozFxDEMN4QBlA5FAga+WrhMrdH5Jop74uqNh4Y1L0I=;
        b=DH4a4mpH2GFihucxfbAY1RaJHvSZKdfYuV8CeTKpwllLFUsJ6adgXpdRXO9ap2KXww
         tVdAsjb+cHKS5Pi3ozkrwYAFFjSB97IAIlCdBKvDVzt2Gtft73vBu0Jg9ZahRie5F0OW
         2HEIpXamqecQYCPWXWkjQzyPcnqyBzZ+DtQR8OtBHdB9fZPeeDHLDXyfDpiEkNk8iW2V
         qguzTg5txEu4qYjsyXuVqGK5F+0Nc3iCAdCjydOXTntbkKPm1VvMa+/x4azCjzc8Md9+
         fOGmG+4+U/aOQ5f+YiYyl/WNwq4QPeY7pVvT94Dcmv/3+S+rd7f8P7JUUvsENqJKlQT3
         YMrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VozFxDEMN4QBlA5FAga+WrhMrdH5Jop74uqNh4Y1L0I=;
        b=oU3MpjcCnnM9dyDqaN5g+adMnTRunDz8M+BhWfolBt/k2spOgQD2k3wBkWOe9DOGi5
         jkVJTvPxfXXnZFKxBe4aoHY8TnPZtkUvI/VRa85XvU9UrroFHwZsrIp1inwjN8+TXU44
         oyUibP1w2BJMyMglchvO+YFIawM3A4iED7mfAB3Bb2Wv4Ly5G1xAcZsVPClOHQKcqHKi
         Uizho6Vx7U+xGVyrXThOOwz+SkSSG4gnxyAv9X0uUyrSqhvH4G2XEOWDKJZsDkFSxPx/
         0xXRvoB1sf2a3NIBUl4hM66hWzoiJPC8qX0Q4o4hHZQ6vm3MUctU84yStZdHW7Czb3td
         weSw==
X-Gm-Message-State: AOAM531+LtAEoYcWSM76oOOEeN4Iwr21YnPjM9PGeb5Sb+2nI7fMeqJe
        PE6uMtSkUnii9ISXDDp4RqjY6Uf1VjJ8Kw==
X-Google-Smtp-Source: ABdhPJxLL7+l08E9QNY1KhAN0eW67V2HJLMnSm6TmWxvJQfHdoKdPN4mZ70tx5wH1GonQM7OHogrvA==
X-Received: by 2002:a5d:610f:: with SMTP id v15mr36381036wrt.236.1618310263864;
        Tue, 13 Apr 2021 03:37:43 -0700 (PDT)
Received: from debian ([78.40.148.180])
        by smtp.gmail.com with ESMTPSA id g132sm2132119wmg.42.2021.04.13.03.37.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 03:37:43 -0700 (PDT)
Date:   Tue, 13 Apr 2021 11:37:41 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 4.19 52/66] net: sched: bump refcount for new action in
 ACT replace mode
Message-ID: <YHV0df3X4/bm3cf2@debian>
References: <20210412083958.129944265@linuxfoundation.org>
 <20210412083959.808110959@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210412083959.808110959@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Apr 12, 2021 at 10:40:58AM +0200, Greg Kroah-Hartman wrote:
> From: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> 
> commit 6855e8213e06efcaf7c02a15e12b1ae64b9a7149 upstream.

This has been reverted upstream by:
4ba86128ba07 ("Revert "net: sched: bump refcount for new action in ACT replace mode"")

--
Regards
Sudip
