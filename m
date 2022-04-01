Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7FE4EE656
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 05:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240392AbiDADCL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 23:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244310AbiDADCI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 23:02:08 -0400
X-Greylist: delayed 580 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 31 Mar 2022 20:00:20 PDT
Received: from vmicros1.altlinux.org (vmicros1.altlinux.org [194.107.17.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5686C17587B
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 20:00:20 -0700 (PDT)
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id EE10172C8B5;
        Fri,  1 Apr 2022 05:50:38 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id D07FE4A4708;
        Fri,  1 Apr 2022 05:50:38 +0300 (MSK)
Date:   Fri, 1 Apr 2022 05:50:38 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org
Subject: Why rolling trees aren't updated last week?
Message-ID: <20220401025038.d4hpgzpl6jnxkyyw@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_50,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

Why linux-rolling-lts and linux-rolling-stable trees aren't updated last
week and stay on the previous lts and stable releases?

Thanks,

