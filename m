Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A342A161D71
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 23:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725867AbgBQWju (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 17:39:50 -0500
Received: from mail-wr1-f42.google.com ([209.85.221.42]:42378 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbgBQWju (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 17:39:50 -0500
Received: by mail-wr1-f42.google.com with SMTP id k11so21604818wrd.9
        for <stable@vger.kernel.org>; Mon, 17 Feb 2020 14:39:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dChui9vsLelyrVNdPQqy+Uhc/gycPyvF2obPDQjgnuw=;
        b=B78+uyfudxjChlk1x1kim+plMcoQxyjWjia6+bLml5FHXfAsnGo8beLRihkJl/f459
         zdPiiKnHX5jjwyxqctJKZcUHlvNTGZ21k7H2xgViiUdlM0rVrVJrM630+mt/hHm2Xep/
         gISkupPo+CO3w9e+fQYIBvGNuYhqb0VpzyZjTtePsLv9wEqIlGNlDqSDPwNZlKT3/7/L
         hBTMe5OrIajXOBMooYxSLikN3iMqy6XjNr0OxPAOz1yPWHmVYR3YdwKulCI3pD2kON8K
         fxV8MVPro5hm632picJ8wrFH4OoUeAKhQI9Uw7JEq5zzM5HJwovwJd5ZhmI9gFaSNxw5
         9qrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dChui9vsLelyrVNdPQqy+Uhc/gycPyvF2obPDQjgnuw=;
        b=Zno988HwOYudjdpMGIBGyjMy6s9i2V1VWN02WkoCJM4rpqBavy9jORurr2N/MK67+9
         aWMphZN/6+wuprueN5H4Pbv2UznLWTtBKKGN6aG7oHSo/NIMh+78Z+R9+/7tkAkWl/h1
         RBz0/U7GSb0xpbDIjxZ7CUJshgCpwTZxfUAQO2RniH8UX60VrI7A2asOJrqi3gkdECIb
         Z20mvl3TgRfB7p2AdR/Z2tdlyEhxuZTxP5RhN0mAlEIT918+cBIqblL2+ttzsakPvbW1
         ssre3ENMaSiBeyEwJ8tzUX6bY7vqBohf6IIt0OIUYoloZXOBx6pXGmzCmbnywLM6QIiS
         0vZA==
X-Gm-Message-State: APjAAAXlVW6OfobVFHJy7//J/4RoZFJqrIHry9tZD2P9BEBiZgRlbXd+
        ugrVMLx1iYe74iUs3Dk71vqNK8hs2XfvEg==
X-Google-Smtp-Source: APXvYqwzxir59YKv8LNGpdXdePsfwN+DgzWMXd3Rbej2NWtY50yOLYq4zSofkS2q4Fiyd61XJHtkSw==
X-Received: by 2002:adf:dd0b:: with SMTP id a11mr25599132wrm.150.1581979187956;
        Mon, 17 Feb 2020 14:39:47 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 2sm2820274wrq.31.2020.02.17.14.39.47
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 14:39:47 -0800 (PST)
Message-ID: <5e4b1633.1c69fb81.6409f.dbec@mx.google.com>
Date:   Mon, 17 Feb 2020 14:39:47 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.20
Subject: stable-rc/linux-5.4.y boot: 22 boots: 0 failed, 22 passed (v5.4.20)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 22 boots: 0 failed, 22 passed (v5.4.20)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.20/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.20/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.20
Git Commit: 27dfbcc2f53d5b14ef78156d15ff92619807d46c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 20 unique boards, 6 SoC families, 7 builds out of 99

---
For more info write to <info@kernelci.org>
