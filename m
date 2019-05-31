Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 450F2316DB
	for <lists+stable@lfdr.de>; Fri, 31 May 2019 23:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbfEaV7w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 May 2019 17:59:52 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:34007 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbfEaV7w (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 May 2019 17:59:52 -0400
Received: by mail-wr1-f45.google.com with SMTP id f8so7433681wrt.1
        for <stable@vger.kernel.org>; Fri, 31 May 2019 14:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kUpLqUgnI1+PrNJHr7rOV4tlYckLWRONCaGlIe9UXrc=;
        b=ePrky56yjEmIlj9XQK+M4ChatZjag2Bkiw3RugIDbUzk4Y7yKI3WJGUCfEzugcJrb7
         siP1//136kqajbdremY/ywHOgRodjPYtiuaEOZPRCO1I6QsCW59hux80KYVxTWyPgBHY
         EgspLNb2be+Gcj/RqsXv5ahAhBhoTAzwgLCjsKdrir8ljujrEE/I/ggSy3yNm3DGxYhk
         A7tJa1H8VWKUd36HSvobfWOx+Iy7C46qEGtu3jH+r7jVrhLglJnGD13oPmbQZoUj5zmi
         yjoa94jBlnS9ouEGnkOJmcX1nqUWNXobL64boGr9AsGDQCMlTREtKWVn4Ds9wmkdMzrH
         i/wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kUpLqUgnI1+PrNJHr7rOV4tlYckLWRONCaGlIe9UXrc=;
        b=GbpanCxV4HwAQM5ciBAWGqtZTZyKB1+RN8rVbYuGHI8Fhc3Rffp+htB3NgIEbkmnkV
         JWbN9zKxiZzDjBQicM4nRniJaT8zcChDEkeY5GzG8gTdBEw59Ln3Vc9IdUoX8DlP2r/Y
         5YLEqT2KJHmPXX2jBXkwlKomdW7u0kaUPXzvsq+zgBd5gKLN2msVOVlHH7o2bcMGX9K9
         wFL6FS+9pJAYY30QukAR+HJdfjzT/N0xZNVy5i45c3JnaUn7hM3KS40CsmmsCfhj1i6W
         LFy/x3y0fg4OawfocoHwoAIWDYJC+0dJc9q0cGUalu0O9xWlXDwOV0Kgr3AMr4jy4F7B
         5cWQ==
X-Gm-Message-State: APjAAAU2xyN+qxO7akiURBNrwNVllGLjUk4bjvhFEYma3QfeHXUcY1pz
        yTcPw61TW9x/0bot7BvyVYU2JYMpfknxTQ==
X-Google-Smtp-Source: APXvYqySui+XSXwp6aX3RZ91mbkaWh4gwHHO+cJaZnWlheo1GZGW9NysUVYs5hBop04V5lHGDudD+w==
X-Received: by 2002:a5d:488b:: with SMTP id g11mr8129143wrq.72.1559339990696;
        Fri, 31 May 2019 14:59:50 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c2sm5768762wrf.75.2019.05.31.14.59.49
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 14:59:49 -0700 (PDT)
Message-ID: <5cf1a3d5.1c69fb81.6c6ed.f476@mx.google.com>
Date:   Fri, 31 May 2019 14:59:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.123
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 119 boots: 0 failed,
 119 passed (v4.14.123)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 119 boots: 0 failed, 119 passed (v4.14.123)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.123/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.123/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.123
Git Commit: 8cb1239889087368a792c655de99529eec219bfc
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 62 unique boards, 23 SoC families, 14 builds out of 201

---
For more info write to <info@kernelci.org>
