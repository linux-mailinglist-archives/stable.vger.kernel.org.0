Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1E4C167D7
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 18:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbfEGQ1C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 12:27:02 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41425 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbfEGQ1C (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 12:27:02 -0400
Received: by mail-wr1-f67.google.com with SMTP id d12so2743737wrm.8
        for <stable@vger.kernel.org>; Tue, 07 May 2019 09:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=+52L+u62TNY6YACkEbpqwAKBYstdSnWBCEy5H39fP9o=;
        b=T5uTiFkzwuZSXQ02GknS7agw9Ku/tQEoGwLeFinH5mNT1fMvJDMVLkzT8O+CgKhwoC
         3WtRaCG5dFDw/DsRA2wYElIOQpNdRteMRAdcjmlg5Kx0oqzO3AjtY1x7CEBbDI8+NtRS
         BC75bFRU0DDJ6jc+ijZvIEMhB/jEabEdEufZ0dzER+7fK4A/Yre5hBWrMKOBNLuNT3Cs
         8ksgArUeilUyIwFvKpCpfSD+ccghy8pmynk54I6FMHtIfUCztd8i1aO/vmoGWxdugFM2
         9psx2iCxH2tXK2IV/ixDhfN1XUkuPTskpKYioe1D9tuRe7IgKFcjYCkGRxvRxcA2h7wI
         ZAUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=+52L+u62TNY6YACkEbpqwAKBYstdSnWBCEy5H39fP9o=;
        b=e4D8vXhLaZIFT5Y2JoblcDxGkUL0h65s35rQcXIysv80SGwGwxvFNGi61sDTeA1Of5
         f02AMA9JDL8c+m0i6Hokiefto7LGSA8+J4ct5wVn5uX+xoEgjVq21Etqw3X512uL3Oop
         aAyiFT6RQHD8n8Xjt8DQLwVCxEoMagI39fF9TXn1U9X0APBkGj8jVXJqNJA/sIAB7vRs
         zAcMWrhDwlHn8vtF3B9XkAEV74iykGNmS6kNNKSViInuZA17UPBXVZNQGWGPrmerOsR7
         zjFtb7qoaz63siMnlgNuLcU8NTKCrzPsNEm3OlmL8YE5cCkNuIgBu/6qQc85IBPd0q/0
         ELJQ==
X-Gm-Message-State: APjAAAUX0xnEOgL4hIKWyOKmtUhGAYbydttWGrr0gHy0ufgezwBramaz
        rA89StTpUiSyean8ekrF1NIgTF2s/etwaQ==
X-Google-Smtp-Source: APXvYqywW2jCRYjL716MqhbCVN/FuKaYokKrqE12i9/pioB1hY60FONsczBqbn6v4W/1x/U92Fk7kw==
X-Received: by 2002:a5d:4711:: with SMTP id y17mr24826288wrq.122.1557246421070;
        Tue, 07 May 2019 09:27:01 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v189sm23678819wma.3.2019.05.07.09.26.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 May 2019 09:27:00 -0700 (PDT)
Message-ID: <5cd1b1d4.1c69fb81.5d408.0a4f@mx.google.com>
Date:   Tue, 07 May 2019 09:27:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.0.y
X-Kernelci-Kernel: v5.0.13-123-g5b4a1a11a18c
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
Subject: Re: [PATCH 5.0 000/122] 5.0.14-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.0.y boot: 56 boots: 0 failed, 56 passed (v5.0.13-123-g5b4=
a1a11a18c)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.0.y/kernel/v5.0.13-123-g5b4a1a11a18c/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.0.y=
/kernel/v5.0.13-123-g5b4a1a11a18c/

Tree: stable-rc
Branch: linux-5.0.y
Git Describe: v5.0.13-123-g5b4a1a11a18c
Git Commit: 5b4a1a11a18cf15168a00c41c55384b2558cdee0
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 25 unique boards, 11 SoC families, 10 builds out of 208

---
For more info write to <info@kernelci.org>
