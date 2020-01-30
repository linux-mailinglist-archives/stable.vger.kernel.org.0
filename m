Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C535B14D651
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 07:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbgA3F7I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 00:59:08 -0500
Received: from mail-wr1-f45.google.com ([209.85.221.45]:38045 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbgA3F7I (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jan 2020 00:59:08 -0500
Received: by mail-wr1-f45.google.com with SMTP id y17so2502630wrh.5
        for <stable@vger.kernel.org>; Wed, 29 Jan 2020 21:59:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=N2kiiyYkOnSy3yLp3aMJQUWMyxC00HfLMR+WexO1ae8=;
        b=urPwsEOavcH6108pyTYTQDO9pEmBQcMM/CbM3HRIscZ5s1tb6y2BNAfGq9lA9ZWHKZ
         y1zV1fRLSufQhoN0GHrhIvPFQ4/J8g+6GhirBBP9g0G1dJA0OH5Fmw0paehX6SN3HeWq
         qZlPDhnbx6msvkqzqz78yPkO/jpMMfvDghALNV/vhvpgf5REa4PKzzMo/qOdaO6KqTnt
         vkbet5khCMuQqUckt3Om8t+fX7KS4C5hkGL7ghW05wSCwGsCKMQR2L9fgcjzu9tPsukt
         8Ky6hTZV926dQnbttgWmCEqyhVhFyD7CrwIFFwiWLLLVJ8MhocEa1F+CpaUwhgF3WCjc
         Fu8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=N2kiiyYkOnSy3yLp3aMJQUWMyxC00HfLMR+WexO1ae8=;
        b=SO7Q71Cb3N8xiGC9HtWbtA/w8bhr6D/T53PGY24mhUtYybQ7logoJnhZ6rdqQxu7In
         5BQymv9Mcd42Ytm8+zzL7GxGRVRfwb+jT1GkvdXqvij92JpgX1lmH9u1VyJy3uWNVX2D
         GQbzGVYRHZi3iGwX5gFjy3jpz/UPrpKyoPUnEm6o0YvbcIpVfwJnTxQyvkXOoLLJ9Xxf
         gbdW0wK9z2jmAea1bZH+1Rtp6aJ20w+yNssQPalEEXe8NjaoIkJ+wkeNct74TpKNGB0F
         iYGfdJgDiGjDj3g2SyICOwzap4bosbIuIcLxCSDtHD9LGuK53unavGsQJShei7n4UaK5
         KnSg==
X-Gm-Message-State: APjAAAVywOcRgMWmsfTpNeCazmx2dHCVJ2kaLKazF+8wqtyL+4LpA4a0
        kbHU5OkY1W59LJDcWurGuLZcUPQKMDCcKQ==
X-Google-Smtp-Source: APXvYqyaou/+jzqwGOHwlIVG8Pk6Fv0iPkRVUqAa9zaInnj7leV0j/zma/6pCnYYNzP+GAGKoDRuFg==
X-Received: by 2002:a5d:6191:: with SMTP id j17mr2959085wru.427.1580363946140;
        Wed, 29 Jan 2020 21:59:06 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id k7sm4865720wmi.19.2020.01.29.21.59.05
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2020 21:59:05 -0800 (PST)
Message-ID: <5e3270a9.1c69fb81.232b7.5f30@mx.google.com>
Date:   Wed, 29 Jan 2020 21:59:05 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Kernel: v4.4.211-184-g475d90ca735c
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 13 boots: 0 failed,
 13 passed (v4.4.211-184-g475d90ca735c)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 13 boots: 0 failed, 13 passed (v4.4.211-184-g47=
5d90ca735c)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.211-184-g475d90ca735c/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.211-184-g475d90ca735c/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.211-184-g475d90ca735c
Git Commit: 475d90ca735ce524de49d9fbe3f1a3fd5655caeb
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 9 unique boards, 4 SoC families, 4 builds out of 162

---
For more info write to <info@kernelci.org>
