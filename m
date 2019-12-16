Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18E4C121EFA
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 00:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbfLPXbV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 18:31:21 -0500
Received: from mail-wr1-f51.google.com ([209.85.221.51]:43916 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726487AbfLPXbV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 18:31:21 -0500
Received: by mail-wr1-f51.google.com with SMTP id d16so9315442wre.10
        for <stable@vger.kernel.org>; Mon, 16 Dec 2019 15:31:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8enuaSUhMdhWy+EpxoCK2xRQwHJJ8FyQl4A8s+3oIVw=;
        b=vLKOwv/Nq6SovJz6Y+oPi1ForUksCgrobhegAXAjHDuCSQRbx8OtsDw7j4hGfow/90
         Z5qPvAkN+WG8tF4lc/C7DgZiE6c2KIwsCLxjE+LsoV5OGTWI1Q5+Whu+49NJfclkYArT
         z/PHxOow7t0VeoWCjcUHXUQJQlOdO7kKXgJunSsSmhZaIfkpMmrzzFZfksKqglrSAKmO
         DPrOzfftqzfe4BZna6/TFYLWdoAGsxcL2Edono2ymVHuXQPAG3a5EO/i8LpiIXJXW3oI
         hyYqxex1lxMAjKysDH1PmD8Gnip4DZ62J0MsiFH7DxRo3uyAUR0QTqhYYTp6ve+0PlVk
         9OpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8enuaSUhMdhWy+EpxoCK2xRQwHJJ8FyQl4A8s+3oIVw=;
        b=Crhm6Nqy5aYc5QE61WVULCrJIxlMedRLI7dMhgAmKDhJ8hsXxp1FyVjVZqG2YloK4C
         5iBNbZrsYWAadr9jG9dYVCcaJ+v8qUxpXkE66F2iggYAMjGJ+J+GujIwIgwbM8gerImP
         F0665sSRuBOh0hlCE5uj/LZhmyK7g/so9j58GoS+ji1bv8m45Ql7K+ulOKx4hMSvC1ls
         1QwUl4/qPqk2FBBKgBxnQnzmfCzd79Uem2LOExGgPtTU+xid147vI+6OeYi+k6q1gOiP
         7FfRwNJm2cC4ItpSAOg0E6purKNzNI/jQhOPrErTKQr0gf/yu7Jx5dXdL8jD+7UU4pWW
         wsVQ==
X-Gm-Message-State: APjAAAWvrY94XVYmg0+ERbg/72phUNl0FZVBgfh/PXgAs3f5DcYXsZfd
        zo7r4cNxik/GhYD1pEY8+zR8lX8eHtM=
X-Google-Smtp-Source: APXvYqzQ4n/FBYxXMjQpYdT6FsD1oiyac1UvFvcHwkVB6U1kSAlWP7X2J1PtOpoK6R3sKhoJzZHa2g==
X-Received: by 2002:adf:df90:: with SMTP id z16mr35346853wrl.273.1576539079107;
        Mon, 16 Dec 2019 15:31:19 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id r6sm23576432wrq.92.2019.12.16.15.31.18
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 15:31:18 -0800 (PST)
Message-ID: <5df813c6.1c69fb81.dc29e.b5b6@mx.google.com>
Date:   Mon, 16 Dec 2019 15:31:18 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.206-139-g2dd7c6485855
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 37 boots: 0 failed,
 37 passed (v4.4.206-139-g2dd7c6485855)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 37 boots: 0 failed, 37 passed (v4.4.206-139-g2d=
d7c6485855)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.206-139-g2dd7c6485855/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.206-139-g2dd7c6485855/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.206-139-g2dd7c6485855
Git Commit: 2dd7c6485855500a7f5efe5183770e3b28fb5f00
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 23 unique boards, 10 SoC families, 9 builds out of 190

---
For more info write to <info@kernelci.org>
