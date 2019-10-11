Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2627D4B3D
	for <lists+stable@lfdr.de>; Sat, 12 Oct 2019 01:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbfJKXzp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 19:55:45 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:32824 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726714AbfJKXzp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Oct 2019 19:55:45 -0400
Received: by mail-wr1-f66.google.com with SMTP id b9so13615022wrs.0
        for <stable@vger.kernel.org>; Fri, 11 Oct 2019 16:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HC2Ru8l53QrhUBxRc0LkLgxCbuxrbQKyIa6jllKnspg=;
        b=QlRRs5GS8fJQ+psX89y/8qtR+JkeRa8c5AT5wV2OqOTeBOEFdXwyL4wSALg/gq4xLf
         ZfFh1mwng8PtNlKzK88sIPCZ1ArGyt5dBcp7oU+YHUB8i6vmN3wDGQtBI1haYV+jbUmM
         VfkfEX8GtCNqZkFYuXWLim1MC+h5NT+BeAxkTHzW2f/TMTEG89ASHaDiV/J4Sweicwad
         E15n9WgmWIQOVBe49WauGG55T2jVL1LNB+144aWR5IrgNSqM4d7NJC5k792wFvaoT0R0
         O1dfSElQ2QU96gfUehhAnhQznMoxl5OlJBiMniX7bs5uwO5zh1j3vFB9xrPEZ5YYykvE
         HjPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HC2Ru8l53QrhUBxRc0LkLgxCbuxrbQKyIa6jllKnspg=;
        b=fkXGRRaIqlt23cYSP4wFasn2+bw5s8LV1MGE4zZGDCW6nua8eBC5fW5viPWZCSamOF
         SP6LSskfCJ9jZm1q3tOyhvE535z1DKIo0IFx6t0x/CAyAXhQWeTdINsS5A1Brty685SH
         8sfMFBsA1Q3vxLBzR1fFRNQCg9W4ToPoIFYLr8MftYDItRC5paNgU9vRxDINPnqzHE3R
         k9V73f3yNkiNVmDhe8+K7UjNK1FqtO+H/PY8xiI2JoPtYfoiO+MRLkqeT+3PeG4pOICd
         rrZ/4pC6RIyZi47EnunwPGir9YpxisP5opWJIPxfGoUeFZ+R46Js9c/jUpz5SkLYsl4V
         AJpg==
X-Gm-Message-State: APjAAAXXE9Zpj6zN9vEPveyg7tfmkZJpXSYOuF8U5DkBKxMB5xnv6Jwp
        na3H5X1JsiTsI2fkm6LNN9Cb6/HUCRzEow==
X-Google-Smtp-Source: APXvYqymToCIUC99bwWIDOWtBWv+7sqXmuRarTry/H0/0/gvB3f5+5SC0ge/4/dfXKJsKvMt4v0fgA==
X-Received: by 2002:adf:e74b:: with SMTP id c11mr14640578wrn.250.1570838143441;
        Fri, 11 Oct 2019 16:55:43 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s9sm12238162wme.36.2019.10.11.16.55.41
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Oct 2019 16:55:42 -0700 (PDT)
Message-ID: <5da1167e.1c69fb81.16a6f.c240@mx.google.com>
Date:   Fri, 11 Oct 2019 16:55:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.149
Subject: stable/linux-4.14.y boot: 59 boots: 0 failed, 59 passed (v4.14.149)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 59 boots: 0 failed, 59 passed (v4.14.149)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.149/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.149/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.149
Git Commit: e132c8d7b58d8dc2c1888f5768454550d1f3ea7b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 38 unique boards, 15 SoC families, 10 builds out of 201

---
For more info write to <info@kernelci.org>
