Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 781884CD9EA
	for <lists+stable@lfdr.de>; Fri,  4 Mar 2022 18:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240354AbiCDRR2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Mar 2022 12:17:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236449AbiCDRR2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Mar 2022 12:17:28 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 971091CD9F0
        for <stable@vger.kernel.org>; Fri,  4 Mar 2022 09:16:40 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 37904210F4
        for <stable@vger.kernel.org>; Fri,  4 Mar 2022 17:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1646414199;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type;
        bh=jPRr6BETQP+NI++lsdh5G4vMyexvB5AsQcrAUkdA19g=;
        b=vuIbzZM9RVfgCbPnphYCMIZ/egncJOATXwYikV5xCcwfqNiDsjtjgO0J2lOLI/0HGRzKKe
        H2kwJlDI/fLiBEuDCqlQ51j65F7fpgE/hTeWq5DuoMNFaFA/fGGdN4zBQ6mXeriEhifY82
        3gG3klYIFzTXATZUTIjizCknZJiX3eo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1646414199;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type;
        bh=jPRr6BETQP+NI++lsdh5G4vMyexvB5AsQcrAUkdA19g=;
        b=JCMj4ZC5Ibp615TXmf9CdRCZBI/gr2v0tipe/ML/PfHx9T+VVBX2NinIoT5EW4F80BuzIq
        cUgwWJB0BOEE83CQ==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 31262A3B85;
        Fri,  4 Mar 2022 17:16:39 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 22A53DA80E; Fri,  4 Mar 2022 18:12:45 +0100 (CET)
Date:   Fri, 4 Mar 2022 18:12:45 +0100
From:   David Sterba <dsterba@suse.cz>
To:     stable@vger.kernel.org
Subject: Two more btrfs fixes for 5.16.x
Message-ID: <20220304171245.GA12643@suse.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

there are two more patches that did not have the CC: stable tag from the
recent series to fix defrag in btrfs. Please add them to 5.16 queue,
both apply cleanly, thanks.

d5633b0dee02  btrfs: defrag: bring back the old file extent search behavior
199257a78bb0  btrfs: defrag: don't use merged extent map for their generation check
