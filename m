Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCD16631AB
	for <lists+stable@lfdr.de>; Tue,  9 Jul 2019 09:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbfGIHQy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jul 2019 03:16:54 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:34095 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbfGIHQy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jul 2019 03:16:54 -0400
Received: by mail-lj1-f196.google.com with SMTP id p17so18524896ljg.1;
        Tue, 09 Jul 2019 00:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7/1AULRy8y1HiEx9Bz+oPrzaAgcFgi9QHXRFRreorpM=;
        b=kMK7sXTRhDn09+Lq0No8DlJyEH4hovFa/bG6ty4U1rmxmSPvu93oNDIpIZMu6ynoKZ
         /Pz11Qv196Y27/HwGj+uqzCDjooH8GSWB5/X0iQIb3iSsbaJqFY89vjbi4TO70a+KYXp
         o8WeyT0EapFDFszpJzcIEGtIj+FHRpAKzThFEWCfOIC4AY2+CC8dg3S1S/kWQBdlmbjx
         yTjC1l7pqibYcatDnXYhym+U1buoH9pREmAiVBHWBTU6aX3wTeGmfS5iCL0gdikilocn
         pWyuEbT9bnBuPjc2B6NeqJ4Gr24abjPN0rN9rois9X7ykigPNP5Gl7+W1epyp9aQMoUV
         C6vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7/1AULRy8y1HiEx9Bz+oPrzaAgcFgi9QHXRFRreorpM=;
        b=K77F6rc7+u0w49SEBnCL60owZ/MbI9oNg0fq2Q6CadA15VB3qk0OITH5F53bxhn3uC
         Wy/V/7pzE+C2a3uYpbprTc4ABwAy0qJzvA045mHSqA9L/wiDPdwJnxaepCcEcW6xH6Q8
         bGmZkMqGPT4Aw4yFinzW9P/+SiCX4pzuLWoMVcrLlbRnIfjV6501qiC+2BtZWwyPzRrN
         rkJVqzVQJaVhyYAJxtsf+AG5Ab17sEXY6ljsHu3G0RcH2FOLNl8ZNy8vGoqvYswmLAmB
         4dm6N9dNzoUi1wYMSIqSCpDRKqMk00mLL7QCf7MO88MVSQm8dIhIR7fxRE/No1IsZiVn
         dm3w==
X-Gm-Message-State: APjAAAXGJRma1jtz3faKCgtIcJYe7q8kIZv7TKuTQnLAxeMzqzU+6/mX
        Aes+MpKGOMSV0Vtt7lhjrv/wNb3jrbWpH6cqomw=
X-Google-Smtp-Source: APXvYqwS8zbNwxZFvKHFNs76fvIN7QW6fSuukg7jtUVNSzJLauZr1E64Ec4qpC9nnhFbGFXWvTHcmX6bxEVoRGnVPlg=
X-Received: by 2002:a2e:5b94:: with SMTP id m20mr12730498lje.7.1562656612479;
 Tue, 09 Jul 2019 00:16:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190708150514.376317156@linuxfoundation.org>
In-Reply-To: <20190708150514.376317156@linuxfoundation.org>
From:   Jack Wang <jack.wang.usish@gmail.com>
Date:   Tue, 9 Jul 2019 09:16:41 +0200
Message-ID: <CA+res+RBxqkAJ8o+_Hrgr9-qnqqbn_iZf=GRnrUXX8rcYrMqeQ@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/56] 4.14.133-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>
> This is the start of the stable review cycle for the 4.14.133 release.
> There are 56 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed 10 Jul 2019 03:03:52 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.133-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Merged and tested with my x86_64 systems, no regression found.

Regards,
Jack Wang @ 1 & 1 IONOS Cloud GmbH
