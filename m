Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86D20161D9C
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 23:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbgBQWvV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 17:51:21 -0500
Received: from mail-wm1-f45.google.com ([209.85.128.45]:36293 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbgBQWvV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 17:51:21 -0500
Received: by mail-wm1-f45.google.com with SMTP id p17so924248wma.1
        for <stable@vger.kernel.org>; Mon, 17 Feb 2020 14:51:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jq7MRHZ9Y/+rchwPYwcnLE4ExC8I6j9gqeMSXVyLjv0=;
        b=R9W1IigWWuJNyJhHe60XR5q8T+uN+UoSwIPgVKx1VhpDUIerzH3s1/Uu0jHA+ZEQMS
         hW7NuguxmM1oAVBfgIekfmhnVvkU2mfHRIOds8y5X7zoRER2yOeJ9Jjd1ojLEcRTUBhW
         nvuGwK01TBTL6pYvwykmN23iqyhXTgaMgm2qL/Hl9uHtMlW8oHIbG1PI/eBgS2Ly/3wy
         STip2Kx0FpkaohvpWIWaxCn+th1hpYckXgcgPagWPPC3nVSaRCn+wRAUmWQj/pSOIZJb
         Kxff3Gp8uDWG3ZPxBQneUvOSgpjA2uUU2CvDBAqJp4Ysnn2bTz3PALsiyLlsrBjgCEoL
         SQjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jq7MRHZ9Y/+rchwPYwcnLE4ExC8I6j9gqeMSXVyLjv0=;
        b=dElLCr5hocF9Yx4PbJLrlw3ZaOqhUJ1Ustoiuc4dlFqLGQILSqVrxzYAMDXJPgCjXr
         SFwK9XjhvzAq+SGUQsRIQYOI+HoX9KkgCq789QtAYZVGkPqqBozrVHdHMO4imjhNyat1
         gtT5UryQZerr+VOuNX78Su3rWfFK1n8Nc9RXs1qNZHyQP8F7hQN99X6Ev/xjREXMKKjm
         Wp5/60NmUeIIKH6m4TpkVqcJAKT+lpj0ZMPxEI60RWbs7FAAcIZOMCq6DwxP9InrOugb
         IDKsKi/R71YK/4cBxM6Zh6zviAQET33v5472akUXzPUcQGatMfkRDiwleoueD9F0iy+6
         ST6A==
X-Gm-Message-State: APjAAAUk+mhl2cRYqZRyrDmdU3N3bgpn8k+QHhWnIZboSSSex7sQr9ty
        A/qtJtyZ8AbtQSvK7iyTokfsKMEYOzqwew==
X-Google-Smtp-Source: APXvYqwAGVF6DMz18KLj4dXNbiAr4e0umGSVcRQ/xxHwlhH84ov42CSCkvlH2bKG4bNXuKR4GbJ/dw==
X-Received: by 2002:a1c:1d09:: with SMTP id d9mr1173126wmd.91.1581979879323;
        Mon, 17 Feb 2020 14:51:19 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id q124sm1744153wme.2.2020.02.17.14.51.18
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 14:51:18 -0800 (PST)
Message-ID: <5e4b18e6.1c69fb81.2e63c.8510@mx.google.com>
Date:   Mon, 17 Feb 2020 14:51:18 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.171
Subject: stable-rc/linux-4.14.y boot: 3 boots: 0 failed, 3 passed (v4.14.171)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 3 boots: 0 failed, 3 passed (v4.14.171)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.171/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.171/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.171
Git Commit: 98db2bf27b9ed2d5ed0b6c9c8a4bfcb127a19796
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 3 unique boards, 1 SoC family, 2 builds out of 16

---
For more info write to <info@kernelci.org>
