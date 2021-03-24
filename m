Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3292334854A
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 00:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233587AbhCXX3j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Mar 2021 19:29:39 -0400
Received: from 99-33-87-210.lightspeed.sntcca.sbcglobal.net ([99.33.87.210]:32946
        "EHLO mail.aaazen.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232543AbhCXX3S (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Mar 2021 19:29:18 -0400
Received: from localhost (localhost [127.0.0.1])
        by thursday.test (OpenSMTPD) with ESMTP id 3b45043a;
        Wed, 24 Mar 2021 23:29:12 +0000 (UTC)
Date:   Wed, 24 Mar 2021 16:29:12 -0700 (PDT)
From:   Richard Narron <richard@aaazen.com>
X-X-Sender: richard@thursday.test
To:     stable <stable@vger.kernel.org>
cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernel test robot <lkp@intel.com>,
        Alexandru Ardelean <aardelean@deviqon.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: [PATCH 5.10 131/157] iio: adc: adi-axi-adc: add proper Kconfig
 dependencies
In-Reply-To: <20210322121937.905867616@linuxfoundation.org>
Message-ID: <alpine.LNX.2.20.2103241620340.7498@thursday.test>
References: <20210322121933.746237845@linuxfoundation.org> <20210322121937.905867616@linuxfoundation.org>
User-Agent: Alpine 2.20 (LNX 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I reported a bug with this patch to 5.11.9-rc1 but it also appears here in
5.10.26-rc1...

Download the config file from Slackware x86_64 current:

https://mirrors.kernel.org/slackware/slackware64-current/source/k/kernel-configs/config-huge-5.10.25.x64

An new warning message appears during configuration:

$make oldconfig
  HOSTCC  scripts/basic/fixdep
  HOSTCC  scripts/kconfig/conf.o
  HOSTCC  scripts/kconfig/expr.o
  HOSTCC  scripts/kconfig/confdata.o
  LEX     scripts/kconfig/lexer.lex.c
  YACC    scripts/kconfig/parser.tab.[ch]
  HOSTCC  scripts/kconfig/preprocess.o
  HOSTCC  scripts/kconfig/symbol.o
  HOSTCC  scripts/kconfig/util.o
  HOSTCC  scripts/kconfig/lexer.lex.o
  HOSTCC  scripts/kconfig/parser.tab.o
  HOSTLD  scripts/kconfig/conf

WARNING: unmet direct dependencies detected for ADI_AXI_ADC
  Depends on [n]: IIO [=m] && HAS_IOMEM [=y] && OF [=n]
  Selected by [m]:
  - AD9467 [=m] && IIO [=m] && SPI [=y]

WARNING: unmet direct dependencies detected for ADI_AXI_ADC
  Depends on [n]: IIO [=m] && HAS_IOMEM [=y] && OF [=n]
  Selected by [m]:
  - AD9467 [=m] && IIO [=m] && SPI [=y]
#
# configuration written to .config
#

