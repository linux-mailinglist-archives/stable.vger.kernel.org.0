Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD89332A7
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 16:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729155AbfFCOtb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 10:49:31 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36974 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729139AbfFCOtb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 10:49:31 -0400
Received: by mail-wm1-f67.google.com with SMTP id 22so3181775wmg.2
        for <stable@vger.kernel.org>; Mon, 03 Jun 2019 07:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=dTxrOsxUCXsXFGn572IgwOw5+RP5dDurYTRimMn6u1g=;
        b=KRQ1ldMqRf+t9uEOltxOnY4Xv3IUu2Ap1UZngM8Y/83u83IYLqnaQHvT8pNr7PKUwn
         jz+y7EF7ispu8qLP0saeTZTKRSFGTsiKgz4wt/NNzxKUBNmh7DJ3OYf//AcsBiWp5ArE
         pJ9kHcTi7pwCHndCWZboOEv3Dqig2KECesxH6SuvIzHuG40TWhNOZxulKi/VjkBmrSkE
         towN5BaUBZ39Jcj54b8U85nzo6ig7haW4v2P8c6gQDgZE1aWxc7xgvxNhl7lRJsXPLca
         IDMbPgGc8NYQPbVA2wtqaT1ZnbLXelaY/RSdoeMSWK/BdqhsVhEBaGgs1K4gv9PWoW3P
         P61A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=dTxrOsxUCXsXFGn572IgwOw5+RP5dDurYTRimMn6u1g=;
        b=G+HT1NlBLBWxk0narGwMMU/3Z5/Wwrz3pp+oYS1/cof/yZi/cIkIFCNlY66PtamWQi
         ypWmp90XNJotVNsJrU4WX5k5vE7A1L1NjaTHOD4aGfLXhF85G6o6rrTYNfD0pnvI23kr
         dblnb9Jz5jIyM4Cqox061uB2VugBDkY6/Sd2UP70c2sC1fMv4lGmXIQh4O8EtA4GDAw0
         LsZvnpFErTXeJgJkH/e8qnD8ldhqG+0la1+de7OdOUwva0dIAfbCOTiCFIjxuFDk/4wd
         HnlKW4FPR938cq6bC4AeXBleAFqoDTR2i7Uw8xNb7brIdLELLuIrAOOuQjxvTWCswHtS
         stWQ==
X-Gm-Message-State: APjAAAXStaR2MHZHyxveetzvs9qkeilbKOFZfItNBo1zZkynsj41pVcu
        WT/2UYNkY6qzcfoQCy7zR37GVA==
X-Google-Smtp-Source: APXvYqxflosKqqZmYHVB8+xU9goQyTfdOA+I5W/YRTVMGyHo/V6JC5v0+imOMtt35U2hPwrOciB7Rw==
X-Received: by 2002:a1c:a186:: with SMTP id k128mr5694176wme.125.1559573369333;
        Mon, 03 Jun 2019 07:49:29 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id r8sm12975277wrt.92.2019.06.03.07.49.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 07:49:28 -0700 (PDT)
Message-ID: <5cf53378.1c69fb81.9dd1b.494b@mx.google.com>
Date:   Mon, 03 Jun 2019 07:49:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.6-41-ge674455b9242
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable-rc
In-Reply-To: <20190603090522.617635820@linuxfoundation.org>
References: <20190603090522.617635820@linuxfoundation.org>
Subject: Re: [PATCH 5.1 00/40] 5.1.7-stable review
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

stable-rc/linux-5.1.y boot: 132 boots: 1 failed, 131 passed (v5.1.6-41-ge67=
4455b9242)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.6-41-ge674455b9242/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.6-41-ge674455b9242/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.6-41-ge674455b9242
Git Commit: e674455b924207b06e6527d961a4b617cf13e7a9
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 73 unique boards, 23 SoC families, 14 builds out of 209

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

---
For more info write to <info@kernelci.org>
