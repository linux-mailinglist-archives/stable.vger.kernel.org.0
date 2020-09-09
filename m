Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 646C92632F4
	for <lists+stable@lfdr.de>; Wed,  9 Sep 2020 18:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730315AbgIIQyd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Sep 2020 12:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730547AbgIIP5T (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Sep 2020 11:57:19 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 744F5C0617AA
        for <stable@vger.kernel.org>; Wed,  9 Sep 2020 06:37:37 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1034)
        id 4BmjkR2Zwbz9sVR; Wed,  9 Sep 2020 23:37:34 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     ajd@linux.ibm.com, christophe_lombard@fr.ibm.com,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Cc:     stable@vger.kernel.org
In-Reply-To: <20200407115601.25453-1-fbarrat@linux.ibm.com>
References: <20200407115601.25453-1-fbarrat@linux.ibm.com>
Subject: Re: [PATCH] cxl: Rework error message for incompatible slots
Message-Id: <159965824206.811679.9265334778679096487.b4-ty@ellerman.id.au>
Date:   Wed,  9 Sep 2020 23:37:34 +1000 (AEST)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 7 Apr 2020 13:56:01 +0200, Frederic Barrat wrote:
> Improve the error message shown if a capi adapter is plugged on a
> capi-incompatible slot directly under the PHB (no intermediate switch).

Applied to powerpc/next.

[1/1] cxl: Rework error message for incompatible slots
      https://git.kernel.org/powerpc/c/40ac790d99c6dd16b367d5c2339e446a5f1b0593

cheers
