Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 131902A762
	for <lists+stable@lfdr.de>; Sun, 26 May 2019 01:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727439AbfEYXg1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 May 2019 19:36:27 -0400
Received: from mail-wr1-f47.google.com ([209.85.221.47]:44759 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727431AbfEYXg1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 May 2019 19:36:27 -0400
Received: by mail-wr1-f47.google.com with SMTP id w13so4956883wru.11
        for <stable@vger.kernel.org>; Sat, 25 May 2019 16:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=a/vGfuAsEULJBhTVrPA3KVBCCfa8I5Y+ra0Qi/Z+qHg=;
        b=zsVqZee8lDh6VJHtMwKuzK0e3SZdkAZnEI6Z7GXDbJwKClQvD5cxC4Xcw7W6h6Mus5
         7myhRkG2CTrWNYbNd2XGMDjEVvcOHJvjEKpenZt3SOaxuGNQ3cXgp9sdWTmXUMcCL/QN
         xPqKN7q1rLt6cgGE5V0zbcwzTCgaoXcF3HHItoSIZ2isBYwAlj4bY2JFj2TP9EyGP0C6
         H08lP2xtBaxe/eaBISzENNjKK+TjYZa73Bnve1rr61nP8qA2TMIusnH3FZpaevPw8eD/
         E7pNMg41eFxeyqngPfKNXcIBtVClv0VLqp+E0pl7ATQoOs7c+rLMeZMqj5dnRpQnaQyj
         Vshw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=a/vGfuAsEULJBhTVrPA3KVBCCfa8I5Y+ra0Qi/Z+qHg=;
        b=kLYrAxEFJxws04IDqa0UCVWIE4ardxPmZpWrKYKQ/ZZktmibimuifk/NpwId0O1Mj+
         TsFdhbKq4aNrAkU/ksFeqK0EwsQeGXAaP+u6sVhgAx3zMNWJsk3rw6jeeE/4OeeZ2hWZ
         3GdnxkngoUZpGWxH9vVdY4WeUlhND0enuoQLOIXIycBjvuVxNYh+QSD3N+kRWJuzsOf6
         2sWTyDq0olh8CiInKVkjzI1167Np0Wky2Sqqrb5f8kN6WdPaKTOawr29oPxq7VAWuYwE
         dsW4VZ+5Jih7CerM75QsEa0wZQHhtnfzT9gqqFKm3TZoRkFvsHLgJsNAmNsr5lpsD9n1
         ozmw==
X-Gm-Message-State: APjAAAVPiHGHv5lJRXcoM/+6hXLsjJ4Fqs4af+MusaEwyj9jfDs/Kv2g
        wxk6yYMRe4SJ46E2rG9Vu/qvwDg3Qpo=
X-Google-Smtp-Source: APXvYqw1yx27QuIOuVDfdDClc+RiN3u0wKmEkigJ7G5YTh2nIvr/PmfJjpBJNKOTisvT5stFv0gJMA==
X-Received: by 2002:adf:efc3:: with SMTP id i3mr53565674wrp.45.1558827385614;
        Sat, 25 May 2019 16:36:25 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 22sm5250810wmg.44.2019.05.25.16.36.24
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 25 May 2019 16:36:24 -0700 (PDT)
Message-ID: <5ce9d178.1c69fb81.e3f9c.c231@mx.google.com>
Date:   Sat, 25 May 2019 16:36:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.46
Subject: stable/linux-4.19.y boot: 55 boots: 0 failed, 55 passed (v4.19.46)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 55 boots: 0 failed, 55 passed (v4.19.46)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.46/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.46/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.46
Git Commit: 8b2fc005825583918be22b7bea6c155061e2f18d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 29 unique boards, 15 SoC families, 11 builds out of 206

---
For more info write to <info@kernelci.org>
