Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87005AD98B
	for <lists+stable@lfdr.de>; Mon,  9 Sep 2019 15:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbfIINAu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Sep 2019 09:00:50 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36629 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbfIINAt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Sep 2019 09:00:49 -0400
Received: by mail-wm1-f65.google.com with SMTP id p13so14600700wmh.1;
        Mon, 09 Sep 2019 06:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2mtaXV7efDqHnLl+I+7SAMFY03vfoRhhBlpiVGaFQk8=;
        b=o5Mu6W+2SUKWlKCtvnhhXFy04FVwBepV5lS1KIj3m+C/9Og0pMUOcf++P4N0w8Yvzz
         ir/ZcGOzKohQvKMr37eVmCE14/ggnYO0b1P390t10x43LCdDJdHdjZqrUflV7uwzOZRn
         +1TN8GpHqhU2rz+SUJFx64QmBlUGeSATBH59Ljcptzl8/Q+sHGn7RFmwjZGlWGZN+Us7
         7iLWHlGrZ5VwnYeMyGpg1YO+gsp424rYI+xCZuUwXzgPyO2UEV1vD2+ytTLbDxYkjFtd
         dvbYvOmk2cm/gvj9uvv6gJGH9THmPDSzLHRJ7g3cEUCenkmjFqtpvjEnDlsvWbdX3whC
         pKDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2mtaXV7efDqHnLl+I+7SAMFY03vfoRhhBlpiVGaFQk8=;
        b=l2DqugTZP7E+gZijTyYuXKZjhUVWQxt89K4EAcm+i7q+ylCrdNGZo96wrpYr9lcQkU
         fn6xjIH7xLfjOdIZ3zbYD+1z28cvt0QrL4L25hlbdpsyRWLQa4nKUgqu/MtiNhXcmaGK
         WPB7H/rIycdz6ry9DPQEucOhWeU7XedXEbw94HDP8PL9hFMLr5Rg2l7VCL5P19c4fqto
         4LbmQlAGOyUMZY19iohK3aA1tnT4XitKNwiIlh+QYOiOggyYbXxIlkzj500eD7tPdn3C
         aRYPm4Af3beDEn+T8b55SUO8RK6Wt2tBzO89iFUj3mgc0egobJF83i+8hjaArayArpNb
         khjA==
X-Gm-Message-State: APjAAAX/GO6QyUDnC+Fb555EnHLs0IUOzFv67x4221nzWDi+adJfuPam
        tKbUPcqc2/0Q1kiUWGGs5pM=
X-Google-Smtp-Source: APXvYqwZNcsdhyfgf9pTofH/0xIuzvtR6S8IvHvjLtdXCPvCCUI3NCXN+ewuYCoam7pbMLdJp4XpPw==
X-Received: by 2002:a1c:a713:: with SMTP id q19mr1412073wme.127.1568034047476;
        Mon, 09 Sep 2019 06:00:47 -0700 (PDT)
Received: from [132.199.67.133] (roam067133.uni-regensburg.de. [132.199.67.133])
        by smtp.gmail.com with ESMTPSA id u8sm11518806wmj.3.2019.09.09.06.00.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Sep 2019 06:00:46 -0700 (PDT)
From:   Fabian Henneke <fabian.henneke@gmail.com>
Subject: Re: [PATCH 4.19 19/57] Bluetooth: hidp: Let hidp_send_message return
 number of queued bytes
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
References: <20190908121125.608195329@linuxfoundation.org>
 <20190908121132.859238319@linuxfoundation.org> <20190909121555.GA18869@amd>
Message-ID: <8e7731e0-f0ad-8cbb-799e-dd585e6b7ed6@gmail.com>
Date:   Mon, 9 Sep 2019 15:00:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190909121555.GA18869@amd>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Mon, Sep 9, 2019 at 2:15 PM Pavel Machek <pavel@denx.de> wrote:

> Hi!
>
> > [ Upstream commit 48d9cc9d85dde37c87abb7ac9bbec6598ba44b56 ]
> >
> > Let hidp_send_message return the number of successfully queued bytes
> > instead of an unconditional 0.
> >
> > With the return value fixed to 0, other drivers relying on hidp, such as
> > hidraw, can not return meaningful values from their respective
> > implementations of write(). In particular, with the current behavior, a
> > hidraw device's write() will have different return values depending on
> > whether the device is connected via USB or Bluetooth, which makes it
> > harder to abstract away the transport layer.
>
> So, does this change any actual behaviour?
>
> Is it fixing a bug, or is it just preparation for a patch that is not
> going to make it to stable?
>

I created this patch specifically in order to ensure that user space
applications can use HID devices with hidraw without needing to care about
whether the transport is USB or Bluetooth. Without the patch, every
hidraw-backed Bluetooth device needs to be treated specially as its write()
violates the usual return value contract, which could be viewed as a bug.

Please note that a later patch (
https://www.spinics.net/lists/linux-input/msg63291.html) fixes some
important error checks that were relying on the old behavior (and were
unfortunately missed by me).

Best regards,
Fabian

>                                                         Pavel
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures)
> http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>

