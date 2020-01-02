Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA2012EB87
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 22:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725851AbgABVwN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 16:52:13 -0500
Received: from mail-wr1-f52.google.com ([209.85.221.52]:44327 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbgABVwN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jan 2020 16:52:13 -0500
Received: by mail-wr1-f52.google.com with SMTP id q10so1723486wrm.11
        for <stable@vger.kernel.org>; Thu, 02 Jan 2020 13:52:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=U+pqTgcE04tvRfjYMCYTR1NajPLJqXoVhGB79EoGsgM=;
        b=NGg8Hc4xOH2vNew5DlLA0Dtu5lYwg1EDfPEsdNE/GL1rmc0LnmsWxHy8g/VrQFA0GW
         1Aoj7+fyload4FMIVFWeEXK+bvhU0kX2ocey/HoJdlFQajWoTBixwL0oIjdqOhs4V6LB
         +aK/w/ejd1gLg//IFfTLr04DvGf0x1YdO3ABVi4v2WDXHFTCkVtjup8FZwo6zon4qVFh
         41Fi0mjpa2jyCeGjd6c1Q2o0yCd5Mxqn6n+gM3h/8//ipy/QGLMOpQ9YFgw7z/ThzvWz
         FrlCVm4BHazjjWGYCus+mjUXOWJYt9HtzhDlDRaeozWHnOD56SKiN2IGaIazq47rRa6w
         ThhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=U+pqTgcE04tvRfjYMCYTR1NajPLJqXoVhGB79EoGsgM=;
        b=fsfsowk3NIF7+2XA1IaqRK4gxcAOUliHKQJJzcmH0SfP7RMuCWLsltr1XudVROisId
         ToWcgrU7ynWpacoLopqne4T6rhDbGA63pR5H9VA3OfUXuObySgrEm/shoxJmbSnn+s7P
         dU3P89HrVLdYENgR2M+dFrGMhl/p7Rjy25wW6izIMTAcIOBWEC/05Pee4YZxzjufI9AK
         /NM+3voDaPDpv+ThdIZCK+/t+blGujufb8LshB8iosgd3eBsKwqtIW+FDSdQqQMyPvrw
         f5pLLT4DXqNF7Q5fbi/U8GaqnoguYvHf6VB8RogvREEgdM+TBeCH6uFKPe6rE7e6VTD7
         dJoA==
X-Gm-Message-State: APjAAAUAGKZHT5agacFNWIYsGfUZ5zIGAgGm+EGS8uDBsZIf5TzNmobK
        GRg3gux5FKkQwZdqeXxt/xilWykGJiq60g==
X-Google-Smtp-Source: APXvYqzvxgicEqKgUjTQk8CXsANgwzhRKv2GOjepY+jq7okItmf81OK/nAxunxejNYEyTmiI0d0sUA==
X-Received: by 2002:adf:e58d:: with SMTP id l13mr81209070wrm.135.1578001929692;
        Thu, 02 Jan 2020 13:52:09 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id p15sm9698117wma.40.2020.01.02.13.52.09
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jan 2020 13:52:09 -0800 (PST)
Message-ID: <5e0e6609.1c69fb81.41bc8.c83b@mx.google.com>
Date:   Thu, 02 Jan 2020 13:52:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.207-138-g666c46c319d9
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 32 boots: 0 failed,
 32 passed (v4.4.207-138-g666c46c319d9)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 32 boots: 0 failed, 32 passed (v4.4.207-138-g66=
6c46c319d9)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.207-138-g666c46c319d9/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.207-138-g666c46c319d9/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.207-138-g666c46c319d9
Git Commit: 666c46c319d9851d8c0cfe5843cc962da28aeba3
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 18 unique boards, 9 SoC families, 9 builds out of 190

---
For more info write to <info@kernelci.org>
