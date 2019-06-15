Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 939F747175
	for <lists+stable@lfdr.de>; Sat, 15 Jun 2019 19:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725796AbfFORoM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jun 2019 13:44:12 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:48742 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbfFORoL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jun 2019 13:44:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=Date:Message-Id:Subject:To:From:
        Sender:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=yVyZ9p9b8gYlYeeAQyREAYNwnYFTCAuhhLyQXnj6bew=; b=Ayb7aTSuyBDEaqnuf+RpSE4vu
        RfOgWWRG1QAieFipmsHqsItYyJhohQeYXSEd/9hKwBzhf2liRps9O7j+QYtkRqeLMrD3xCXF9QfbG
        iYw+U/8oz8Tjd7UVRrr2Vj+zTd/u/5pR8B9k6tLY7v9G7oy5uadFpmSK6CA/ThjCzKkHs=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=optimist)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <broonie@sirena.org.uk>)
        id 1hcCio-0004Gj-RG; Sat, 15 Jun 2019 17:44:10 +0000
Received: from broonie by optimist with local (Exim 4.89)
        (envelope-from <broonie@sirena.org.uk>)
        id 1hcCin-0007A8-MR; Sat, 15 Jun 2019 18:44:09 +0100
From:   Build bot for Mark Brown <broonie@kernel.org>
To:     kernel-build-reports@lists.linaro.org,
        linaro-kernel@lists.linaro.org, stable@vger.kernel.org
Subject: v4.4.181 build: 0 failures 1 warnings (v4.4.181)
Message-Id: <E1hcCin-0007A8-MR@optimist>
Date:   Sat, 15 Jun 2019 18:44:09 +0100
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tree/Branch: v4.4.181
Git describe: v4.4.181
Commit: d7b7345c3a Linux 4.4.181

Build Time: 67 min 57 sec

Passed:   10 / 10   (100.00 %)
Failed:    0 / 10   (  0.00 %)

Errors: 0
Warnings: 1
Section Mismatches: 0

-------------------------------------------------------------------------------
defconfigs with issues (other than build errors):
      3 warnings    0 mismatches  : arm64-allmodconfig

-------------------------------------------------------------------------------

Warnings Summary: 1
	  3 warning: (IMA) selects TCG_CRB which has unmet direct dependencies (TCG_TPM && X86 && ACPI)



===============================================================================
Detailed per-defconfig build reports below:


-------------------------------------------------------------------------------
arm64-allmodconfig : PASS, 0 errors, 3 warnings, 0 section mismatches

Warnings:
	warning: (IMA) selects TCG_CRB which has unmet direct dependencies (TCG_TPM && X86 && ACPI)
	warning: (IMA) selects TCG_CRB which has unmet direct dependencies (TCG_TPM && X86 && ACPI)
	warning: (IMA) selects TCG_CRB which has unmet direct dependencies (TCG_TPM && X86 && ACPI)
-------------------------------------------------------------------------------

Passed with no errors, warnings or mismatches:

arm64-allnoconfig
arm-multi_v5_defconfig
arm-multi_v7_defconfig
x86_64-defconfig
arm-allmodconfig
arm-allnoconfig
x86_64-allnoconfig
x86_64-allmodconfig
arm64-defconfig
