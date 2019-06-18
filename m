Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 449E64974A
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 04:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbfFRCKu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 22:10:50 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44844 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbfFRCKu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jun 2019 22:10:50 -0400
Received: by mail-wr1-f68.google.com with SMTP id r16so12058117wrl.11
        for <stable@vger.kernel.org>; Mon, 17 Jun 2019 19:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=QdfSFaHZxqOQnZpuak6zWlNXji2dmIrBwGxFI1wS7+U=;
        b=Fw0s+dnSWgRsdQoysGIzRfeT9dEE8ID/HRqXifdScAg7DqiDZUMOZOPh3S6UNzfQJ/
         1yIGUsHpdj7keHXtJAhZPE8A0//qyEE7l7HqzRNfVAX0PHT57SEtncquYXf7xw5bbSLd
         CajeIfj6kJhBa8iSERlLDdalHh62z5G/iqgKBiEXfDZf2DqKQS62rMb+GmWB2V/OpK3O
         Bco8MgZoRJ7lCOJ9aIIprgtT6d9mk85O+sTrG9/VPhyOUnnC0u25A3HcZznwINj9PNAF
         TEcXr7mXxTI70faNGnjCfPy6RpIXSzKFmbHZncPdzUalg4UJQghP2j5N+n3OpkFzGguE
         qNPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=QdfSFaHZxqOQnZpuak6zWlNXji2dmIrBwGxFI1wS7+U=;
        b=Ql/n/xaJeiP6tohcjAVWmv0OLEA8phBP2+kd214fLnAX98tLBRx1i3D7NSgarFzX+B
         OmtyO+/zr4NK1AqvwMisoDXZ2K7h1Tm4WglSy5Ks7srHGM02eamNHa+CcodayhRe2Cri
         zp2qVuBvWb16xxQjgkARQMAg/UrwBzu5+IbChbMECdhTjsMiHSAq4IMF+8CS03+nBz6W
         ip0caskdYIth9dmuctWX0pjd0Jmrlp1EpBCY2wUr95Rc3NSiOSYux01htIzDnnYOK5/n
         Ye/jTsWhXEcO12gLvYwiypjFnj42OfY5a+ZA6NED7NZZgq0YKS4KkgKxma+7aBMq7BsW
         rt9Q==
X-Gm-Message-State: APjAAAVM0yHZ+HRZ75aAEvjBSwtszSNey1kgxlpcQlEWwT6shXMAGo/P
        rv8TP2OYJZKzQBEke0Yw0raDOw==
X-Google-Smtp-Source: APXvYqwiEm9DoQKukITRWUaxtn9MCgqVmFdfUDHUEROyISBlo+VsmqW/yQv5WUyH+DqEyHEmQ3xN8Q==
X-Received: by 2002:adf:afde:: with SMTP id y30mr17706287wrd.197.1560823847856;
        Mon, 17 Jun 2019 19:10:47 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id j17sm11538710wrw.6.2019.06.17.19.10.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 19:10:47 -0700 (PDT)
Message-ID: <5d084827.1c69fb81.708ea.ca74@mx.google.com>
Date:   Mon, 17 Jun 2019 19:10:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.11-116-ga1610563f19b
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable-rc
In-Reply-To: <20190617210759.929316339@linuxfoundation.org>
References: <20190617210759.929316339@linuxfoundation.org>
Subject: Re: [PATCH 5.1 000/115] 5.1.12-stable review
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

stable-rc/linux-5.1.y boot: 118 boots: 1 failed, 117 passed (v5.1.11-116-ga=
1610563f19b)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.11-116-ga1610563f19b/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.11-116-ga1610563f19b/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.11-116-ga1610563f19b
Git Commit: a1610563f19b8c84324c5b490e57ffd1f1bb62be
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 70 unique boards, 24 SoC families, 15 builds out of 209

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

---
For more info write to <info@kernelci.org>
