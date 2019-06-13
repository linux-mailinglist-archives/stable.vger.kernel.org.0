Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A21C0437CB
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 17:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732991AbfFMPBH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 11:01:07 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35065 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732563AbfFMOjR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 10:39:17 -0400
Received: by mail-wm1-f68.google.com with SMTP id c6so10423145wml.0
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 07:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Twr9lk+Ihp7LXLOjk1OYLgD3+x2G71hrq8z0bM9CCM8=;
        b=ln9KKsg6Q59sBSZbiXj9DAjblW0ExGaCHDf3mbU0tmug8beXuDDE9dfIgdSzOpoxIv
         ooI+0fZwWPoNp6Xwu520QlrqBaqOaFrG6M5QdD2wp9BjIsVR+BdzcJidKBbfhUcG8BUE
         AMkdKuZneSDIm9GnDWs23Xb6ocNjqRo0eHVONISHG9H91vHf8BINzxaFKpQro1KOP5yT
         Sh7bMPAIq7+gKlFRy78aLi1op3txekpWV+Rq2CqvGXvs9sCFfYsaetsnlHvw3FBsRy6J
         q3MEsmsxUmsyyxzDqBaTf60m9bXSba0LsZaxOhVaoJnc53MkujZrznEuaK+pS8gQ50GN
         mAPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Twr9lk+Ihp7LXLOjk1OYLgD3+x2G71hrq8z0bM9CCM8=;
        b=YHnGi6ZqeZNod4ZsDlYvyq7pQaBr4w333VLTjYtJZYWL+VfqvtiKskLMJj50TPyZ+j
         Qzrjzg6AI7S/+BSUVuYYC2WoDLpiHLcXjxwNIgIwRvVX5sNrIloUPds8EJfDReLT4gHQ
         7Z3JJ5XIR6aFAIuEuHNZ3o2lvJfe9Y2KyOyyap/vywpHGDPZF48kt2kEJrcLfPQQZuAt
         6SgwycZknRRhfgwgqQ7vJRZbbQDSW7A2oVmaFajw98oRi/JgkmDYr0RCqUjpY0u+fCb9
         zkh9eTMTW1th9ZIGLsbtU5yHFKl8wLpEavvSIJR/eGmUCsdPZu59Zjk6NWQGFcN9ik1e
         qAVA==
X-Gm-Message-State: APjAAAXeFuYEztjwWHFu+DtTE8HRm4ZEMZa2/s3X7c3PHgFC39w5Zy4u
        rO8XSaox/qDXmQQ6fHNDM2QZKwzAVNs4HQ==
X-Google-Smtp-Source: APXvYqyWUqJguq1UZDGiMQIOLBo3ItbJWifwP5iinyLE1WIcYwMRDgqAuatO9VYKFnYWvXuEnNQJOw==
X-Received: by 2002:a05:600c:204c:: with SMTP id p12mr4075373wmg.121.1560436755402;
        Thu, 13 Jun 2019 07:39:15 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id p13sm1578320wrt.67.2019.06.13.07.39.14
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 07:39:14 -0700 (PDT)
Message-ID: <5d026012.1c69fb81.914de.7ef7@mx.google.com>
Date:   Thu, 13 Jun 2019 07:39:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.181-42-gd107d3020e01
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y boot: 89 boots: 1 failed,
 88 passed (v4.4.181-42-gd107d3020e01)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 89 boots: 1 failed, 88 passed (v4.4.181-42-gd10=
7d3020e01)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.181-42-gd107d3020e01/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.181-42-gd107d3020e01/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.181-42-gd107d3020e01
Git Commit: d107d3020e0104fd751cad218c2b5897cfe3dfe2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 42 unique boards, 20 SoC families, 14 builds out of 190

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

---
For more info write to <info@kernelci.org>
