Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 713A16ACA31
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 18:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbjCFR2E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 12:28:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjCFR2D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 12:28:03 -0500
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A0D867803
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 09:27:30 -0800 (PST)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 4AD9132009AC;
        Mon,  6 Mar 2023 12:26:08 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 06 Mar 2023 12:26:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; t=1678123567; x=1678209967; bh=ju
        38mYQin9BlLL+npd5I0vFzjhAY3TVCLiqj8MmEYWY=; b=dpTszYKZdC2eKoxrU6
        gTaPm1mwiS1kfsIyRM3Np0l8Z4tnXwPSGgO/R4BfhaseDLclP/8qjmZ5AWfgokSr
        t7PbxnxQu/Vt1apxjE1vjbXZk7lHJM1igmAjUI883BXZiYblV9xGFPwNzTEldcnv
        gDNbQppY1Rl1tYL231OdyITUnAAxSUEl1VnpROmiTJ3UJBzM5SOe128+QLSj03qw
        HFG+Kq2gQFOCbYAiU6V1Id5etKT7g/SMwArwjMTpVjHurdecC4IhzcI2SbB+2vOs
        4F2pgf8VAYggEfkct5Va/iTg/r4Vw/ZKcBpEaXatSvqcXbV59PP2eM7mDE3fvhk9
        QCLg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1678123567; x=1678209967; bh=ju38mYQin9BlL
        L+npd5I0vFzjhAY3TVCLiqj8MmEYWY=; b=sv1xZlE5eGT1L+1UH0K6oBFwYEk4L
        tg4rAMnHDR730r+UsDrCSotZtTXMFkhiGR9LEaHrtacPPTnjpPGFr8yYsq2hU+2c
        CkfoPoREsdEThMkfm3LifuZaLnIgPv9jzfEK8Wuzlgzx3cXIbJ1gkEEAyPZGlrw9
        JKANujYvXq2uAL8kAc3A3kzGSUm/mAyl+RMBmo0nFoVRSGuVZffkJbw0AD5/5CRw
        ni/hRODJGZ6hJw5n7M21q4q9/x3whtJJsI8THujNlVKMhVumGuZBKqhm5vkaEal9
        aTJ6IbOOtVxKCN8NJ6elZT71MmY69KNa0JGNixWsP2Wew01vlHqQ6eWyQ==
X-ME-Sender: <xms:LyIGZNxsTlchunWvxjq_-zGZ4pIhV9nMeO7bFA3hGQGQoQDhGMWOaQ>
    <xme:LyIGZNQd-AwuNFngaVQ6gjFZws3RFzDKOiD1Oehe6kpSTFtzxZwUG0dkhcrswT9ha
    N5PC80Wg7Wq8g>
X-ME-Received: <xmr:LyIGZHWDQb999Cy7B8HeKZvv2YuxpydGrlVssrcb2MKVwszXiPivP6Uj7TJlAh8NzByISL1Ots-zebXGXbhqd6ryj85ZvGXI_WwX3w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvddtkedgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfhfgggtuggjsehttd
    ertddttddvnecuhfhrohhmpefirhgvghcumffjuceoghhrvghgsehkrhhorghhrdgtohhm
    qeenucggtffrrghtthgvrhhnpeegheeuhefgtdeluddtleekfeegjeetgeeikeehfeduie
    ffvddufeefleevtddtvdenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:LyIGZPiCvzWgHC5_Glgxp_zxUSnw3irT58V_qELejtkUHKfpwNKHLQ>
    <xmx:LyIGZPBXGfsyagtmWGg6oqj8IcPoXJEU-HnApWfR2cnOeE4iwOhp6g>
    <xmx:LyIGZIKt8mDGoeG1WzhjO5E6GRY6Ea1tm_JZ9WMgqYIVrIss9kJ9qQ>
    <xmx:LyIGZB3B4EbyoLCeOR54-fNhuRcxzVOEHDiHG2YfHf4aztBoIKBi2w>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 6 Mar 2023 12:26:07 -0500 (EST)
Date:   Mon, 6 Mar 2023 18:26:04 +0100
From:   Greg KH <greg@kroah.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     stable@vger.kernel.org, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Subject: Re: [PATCH 5.4.y] KVM: s390: disable migration mode when dirty
 tracking is disabled
Message-ID: <ZAYiLCkl+nuabM4h@kroah.com>
References: <167810000636131@kroah.com>
 <20230306151331.4531-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230306151331.4531-1-nrb@linux.ibm.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 06, 2023 at 04:13:31PM +0100, Nico Boehr wrote:
> Migration mode is a VM attribute which enables tracking of changes in
> storage attributes (PGSTE). It assumes dirty tracking is enabled on all
> memslots to keep a dirty bitmap of pages with changed storage attributes.
> 
> When enabling migration mode, we currently check that dirty tracking is
> enabled for all memslots. However, userspace can disable dirty tracking
> without disabling migration mode.
> 
> Since migration mode is pointless with dirty tracking disabled, disable
> migration mode whenever userspace disables dirty tracking on any slot.
> 
> Also update the documentation to clarify that dirty tracking must be
> enabled when enabling migration mode, which is already enforced by the
> code in kvm_s390_vm_start_migration().
> 
> Also highlight in the documentation for KVM_S390_GET_CMMA_BITS that it
> can now fail with -EINVAL when dirty tracking is disabled while
> migration mode is on. Move all the error codes to a table so this stays
> readable.
> 
> To disable migration mode, slots_lock should be held, which is taken
> in kvm_set_memory_region() and thus held in
> kvm_arch_prepare_memory_region().
> 
> Restructure the prepare code a bit so all the sanity checking is done
> before disabling migration mode. This ensures migration mode isn't
> disabled when some sanity check fails.
> 
> Cc: stable@vger.kernel.org
> Fixes: 190df4a212a7 ("KVM: s390: CMMA tracking, ESSA emulation, migration mode")
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Link: https://lore.kernel.org/r/20230127140532.230651-2-nrb@linux.ibm.com
> Message-Id: <20230127140532.230651-2-nrb@linux.ibm.com>
> [frankja@linux.ibm.com: fixed commit message typo, moved api.rst error table upwards]
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> (cherry picked from commit f2d3155e2a6bac44d16f04415a321e8707d895c6)
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

Thanks, all backports now queued up.

greg k-h
