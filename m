Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6918D53FDA8
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 13:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237616AbiFGLkI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 07:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243091AbiFGLkH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 07:40:07 -0400
Received: from mailout.rz.uni-frankfurt.de (mailout.rz.uni-frankfurt.de [141.2.22.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF481A8695
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 04:40:05 -0700 (PDT)
Received: from smtpauth1.cluster.uni-frankfurt.de ([10.1.1.45])
        by mailout.rz.uni-frankfurt.de with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <sattler@med.uni-frankfurt.de>)
        id 1nyXZ5-00013t-LG; Tue, 07 Jun 2022 13:40:03 +0200
Received: from p57bcf684.dip0.t-ipconnect.de ([87.188.246.132] helo=[192.168.2.17])
        by smtpauth1.cluster.uni-frankfurt.de with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <sattler@med.uni-frankfurt.de>)
        id 1nyXZ5-0005DF-Jb; Tue, 07 Jun 2022 13:40:03 +0200
Message-ID: <4dc96ed3-169e-37b9-7b8f-85e58dca0bbf@med.uni-frankfurt.de>
Date:   Tue, 7 Jun 2022 13:40:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: boot loop since 5.17.6
Content-Language: en-US
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev
References: <11495172-41dd-5c44-3ef6-8d3ff3ebd1b2@med.uni-frankfurt.de>
 <c3b370a8-193e-329b-c73a-1371bd62edf3@med.uni-frankfurt.de>
 <181a6369-e373-b020-2059-33fb5161d8d3@med.uni-frankfurt.de>
 <YpksflOG2Y1Xng89@dev-arch.thelio-3990X>
 <1f8a4bec-53bd-aaaa-49a7-b5ed4fc5ae34@med.uni-frankfurt.de>
 <a9a68c68-8830-2aa0-acbe-d5d3bb04968f@leemhuis.info>
From:   Thomas Sattler <sattler@med.uni-frankfurt.de>
In-Reply-To: <a9a68c68-8830-2aa0-acbe-d5d3bb04968f@leemhuis.info>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Thorsten,

I just compiled 5.19-rc1 and my issue is solved there.

Thomas
