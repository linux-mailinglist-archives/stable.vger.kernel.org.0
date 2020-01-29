Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDCE14C8B1
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 11:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726091AbgA2KWt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jan 2020 05:22:49 -0500
Received: from mail-wr1-f42.google.com ([209.85.221.42]:33760 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbgA2KWt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jan 2020 05:22:49 -0500
Received: by mail-wr1-f42.google.com with SMTP id b6so19533991wrq.0
        for <stable@vger.kernel.org>; Wed, 29 Jan 2020 02:22:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qeERwEPAngN9phbERwgcfQ4h3/WtZp27GoT41WT1boY=;
        b=q1o+YCKMTWhCxf0Z1OmNXsKyBgvAHw/vHo09iUqyhMZHNetem+UskRH5r3u+IIL4u0
         8RZL+G5UKekofil4F5JwLkcO6wZdzzuJkZuZGddfZtyNongYIjqfMeN7GFuWMOFt+2Ln
         x5TsapeFPejCxaaU1dBcGhWU8C6bxO50sUtT9xnqpOmTjnrdPsQSGVDuLy/im3fipF7n
         mDJDUL1S+Kmowfh/7mwGEc78n11CSomxldhVEeabmAm26rSZ4DqJgeYAjyWo5QIVNj4p
         N+Zp6oJwp/3pF3J9bW1RxDZdce2vji6Zh0vH1YJrf5TOwqUGT6mijJ/H8OVYAukWvZNU
         v0dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qeERwEPAngN9phbERwgcfQ4h3/WtZp27GoT41WT1boY=;
        b=jFNIilxOl4GG2oh3eil+tMRHCfFcGtPGMQz8msJGcWfSVHNtfY5nwnudAMFlOGtgiu
         gZDVWOczfZUc8NTQaGEBJLxGTxEkwrnzNrO7pmb4btRFNtO44Zqytoy0bqLnjx8tB3uu
         fH/0uJxyq/xazN2UMj0jGLOUcOARYenbjxpiqQ7KXdxTKdpJkE0+TcAraqeXMF1GZUhk
         NPEd4DkHVD0EqEgP464GoAtChsbkhllvY5GR2Bkv87AubYrll+xOMOFrjlkYIjLPhc3N
         zEx710scKLopbv3SrOERYETe15vwJYZvz1CWeQw5FzSvvD/16qFxgU+SltxDZxNpNDtF
         lWFQ==
X-Gm-Message-State: APjAAAUMEhhdw6g8pD7jyLg0b1drQjV3hWhg4hzP7xO9pcGUNnQNFQnM
        s7nfsl6TTAsu0HBNpK9lbH1BpMmR2RlVmw==
X-Google-Smtp-Source: APXvYqxHua01Mv9qkGjSwe18USDjsSsAPNVSpHZtuIaZUDGdxKbT8cXjg0a+6/BvcBkVThjrXdRhew==
X-Received: by 2002:a05:6000:1044:: with SMTP id c4mr36671787wrx.204.1580293367361;
        Wed, 29 Jan 2020 02:22:47 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id q3sm2293692wrn.33.2020.01.29.02.22.46
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2020 02:22:46 -0800 (PST)
Message-ID: <5e315cf6.1c69fb81.93d9f.9643@mx.google.com>
Date:   Wed, 29 Jan 2020 02:22:46 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.168-47-g5986a79ae284
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.14.y boot: 37 boots: 0 failed,
 37 passed (v4.14.168-47-g5986a79ae284)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 37 boots: 0 failed, 37 passed (v4.14.168-47-g5=
986a79ae284)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.168-47-g5986a79ae284/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.168-47-g5986a79ae284/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.168-47-g5986a79ae284
Git Commit: 5986a79ae28421d7027cb4ab78fba7d787a9f06e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 23 unique boards, 9 SoC families, 7 builds out of 187

---
For more info write to <info@kernelci.org>
