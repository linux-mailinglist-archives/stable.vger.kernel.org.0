Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA811550A69
	for <lists+stable@lfdr.de>; Sun, 19 Jun 2022 13:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236743AbiFSL4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jun 2022 07:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236802AbiFSL4b (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Jun 2022 07:56:31 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3BAE120A6
        for <stable@vger.kernel.org>; Sun, 19 Jun 2022 04:56:30 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4LQrph6qrqz4xXF;
        Sun, 19 Jun 2022 21:56:28 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     linuxppc-dev@lists.ozlabs.org, Andrew Donnellan <ajd@linux.ibm.com>
Cc:     Sathvika Vasireddy <sathvika@linux.ibm.com>,
        stable@vger.kernel.org, Nathan Lynch <nathanl@linux.ibm.com>
In-Reply-To: <20220614134952.156010-1-ajd@linux.ibm.com>
References: <20220614134952.156010-1-ajd@linux.ibm.com>
Subject: Re: [PATCH] powerpc/rtas: Allow ibm,platform-dump RTAS call with null buffer address
Message-Id: <165563974889.2516477.9308896620875536366.b4-ty@ellerman.id.au>
Date:   Sun, 19 Jun 2022 21:55:48 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 14 Jun 2022 23:49:52 +1000, Andrew Donnellan wrote:
> Add a special case to block_rtas_call() to allow the ibm,platform-dump RTAS
> call through the RTAS filter if the buffer address is 0.
> 
> According to PAPR, ibm,platform-dump is called with a null buffer address
> to notify the platform firmware that processing of a particular dump is
> finished.
> 
> [...]

Applied to powerpc/fixes.

[1/1] powerpc/rtas: Allow ibm,platform-dump RTAS call with null buffer address
      https://git.kernel.org/powerpc/c/7bc08056a6dabc3a1442216daf527edf61ac24b6

cheers
