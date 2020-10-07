Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3EA5285701
	for <lists+stable@lfdr.de>; Wed,  7 Oct 2020 05:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgJGDVM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Oct 2020 23:21:12 -0400
Received: from ozlabs.org ([203.11.71.1]:44651 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726002AbgJGDVM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Oct 2020 23:21:12 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 4C5fkH1lfVz9sTR; Wed,  7 Oct 2020 14:21:11 +1100 (AEDT)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Andrew Donnellan <ajd@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org
Cc:     leobras.c@gmail.com, nathanl@linux.ibm.com, stable@vger.kernel.org,
        dja@axtens.net
In-Reply-To: <20200820044512.7543-1-ajd@linux.ibm.com>
References: <20200820044512.7543-1-ajd@linux.ibm.com>
Subject: Re: [PATCH v2 1/2] powerpc/rtas: Restrict RTAS requests from userspace
Message-Id: <160204083771.257875.2183236339326581440.b4-ty@ellerman.id.au>
Date:   Wed,  7 Oct 2020 14:21:11 +1100 (AEDT)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 20 Aug 2020 14:45:12 +1000, Andrew Donnellan wrote:
> A number of userspace utilities depend on making calls to RTAS to retrieve
> information and update various things.
> 
> The existing API through which we expose RTAS to userspace exposes more
> RTAS functionality than we actually need, through the sys_rtas syscall,
> which allows root (or anyone with CAP_SYS_ADMIN) to make any RTAS call they
> want with arbitrary arguments.
> 
> [...]

Applied to powerpc/next.

[1/2] powerpc/rtas: Restrict RTAS requests from userspace
      https://git.kernel.org/powerpc/c/bd59380c5ba4147dcbaad3e582b55ccfd120b764
[2/2] selftests/powerpc: Add a rtas_filter selftest
      https://git.kernel.org/powerpc/c/dc9af82ea0614bb138705d1f5230d53b3b1dfb83

cheers
