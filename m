Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74FFF12E104
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 00:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbgAAXhH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jan 2020 18:37:07 -0500
Received: from mail-wr1-f41.google.com ([209.85.221.41]:44091 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727393AbgAAXhH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jan 2020 18:37:07 -0500
Received: by mail-wr1-f41.google.com with SMTP id q10so37804306wrm.11
        for <stable@vger.kernel.org>; Wed, 01 Jan 2020 15:37:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NvwgUura2WC5DAMsUpMckgI4ZmtW450bHQR9eiqM6Y0=;
        b=0mXWsAS9tHSzZ6TJlN7yXjqwxf93K4vU04WXsajoENYXYnxUMM7FtsuGShsNKQ6uA7
         Ut9YIpf6daaCLQA34Sma04R2oCIMOrgmiF81Y0pB13PDMDRenSsu/apkLe3B9oYnFPfQ
         nuy5uqg7Hhzq4KUBsOgORnIAoOeo1h57AhxZ2tdvgdSP0+PuMn1youBbFOiXpgAAtTtJ
         YPmLQNzhDD3xo36q62yY/3X1kvPnUezw12gv9VFpCNMVVvF8O++qjj3lnopXwiRtw58q
         POrz7oVwu4D92+W7fgbaeZ0OOPBXotygukaOFgaTw/CQt8Y019qBUS6EVS9NCF1g5lO1
         Ro4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NvwgUura2WC5DAMsUpMckgI4ZmtW450bHQR9eiqM6Y0=;
        b=J5CZsej09pr9kn7In/IZGqglDwrgqoxtn/+VbrdFyF1o6lBU78EilXcssA/pYn0iqj
         G3NfpoQJTtTcVoav4WqJfUnTNXeomnnrAPICSnnT8R5TwkaPlW2BvThx1qTwAqLZZsx8
         9mCdJ4fAJLz5EP35LWsBnXlGK4s6lEQGyRU/bq8UU1D+tUBfZMfNd2WJaKrXWzTo+6qs
         0Vk/bzg71HD0Nk2bAFWC7pMuGyGBn7GhdZdUz9WCpuUcwk0n+EebWpZsCrdjEXS5nGeB
         ED3KN7O08aTucdwRtPt6NF6h6rdNyvotipcHykCR3zjvyApYCAxmIyzzlA4Bbw4vB6CY
         x/Tg==
X-Gm-Message-State: APjAAAVQ/PXFEzqgZQhaEYk/J0AalTl9A8wcWHjJouDLJOQtd1GUFz1K
        ibkpzM76DURk755e1/0WQj057IxKy+fudA==
X-Google-Smtp-Source: APXvYqxuFhLlsUeFv3nofxYVzCd37rlqsbCNT55K2ztpuYP9Cw8WyXLGcDfZVRAGil+9QiaGAPNjLg==
X-Received: by 2002:adf:814c:: with SMTP id 70mr76139718wrm.157.1577921825325;
        Wed, 01 Jan 2020 15:37:05 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id u22sm57726971wru.30.2020.01.01.15.37.04
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jan 2020 15:37:04 -0800 (PST)
Message-ID: <5e0d2d20.1c69fb81.f2db1.8fce@mx.google.com>
Date:   Wed, 01 Jan 2020 15:37:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.207-136-g375f24644bef
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 36 boots: 0 failed,
 36 passed (v4.4.207-136-g375f24644bef)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 36 boots: 0 failed, 36 passed (v4.4.207-136-g37=
5f24644bef)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.207-136-g375f24644bef/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.207-136-g375f24644bef/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.207-136-g375f24644bef
Git Commit: 375f24644bef51fa102699a3f74d67b7b93ea0c5
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 20 unique boards, 9 SoC families, 9 builds out of 190

---
For more info write to <info@kernelci.org>
