Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97F095D9FC
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 02:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbfGCA6o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 20:58:44 -0400
Received: from mail.us.es ([193.147.175.20]:46454 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727251AbfGCA6o (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 20:58:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7C49580783
        for <stable@vger.kernel.org>; Wed,  3 Jul 2019 01:43:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6E2C8DA708
        for <stable@vger.kernel.org>; Wed,  3 Jul 2019 01:43:24 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 63BD1DA7B6; Wed,  3 Jul 2019 01:43:24 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0FA3DDA708;
        Wed,  3 Jul 2019 01:43:22 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 03 Jul 2019 01:43:22 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E0AEA4265A31;
        Wed,  3 Jul 2019 01:43:21 +0200 (CEST)
Date:   Wed, 3 Jul 2019 01:43:21 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: netfilter patches for -stable
Message-ID: <20190702234321.cwqnmqhfymfg6hqh@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Would you consider to take the following patches for -stable?

e75b3e1c9bc5 netfilter: nf_flow_table: ignore DF bit setting
8437a6209f76 netfilter: nft_flow_offload: set liberal tracking mode for tcp
91a9048f2380 netfilter: nft_flow_offload: don't offload when sequence numbers need adjustment
69aeb538587e netfilter: nft_flow_offload: IPCB is only valid for ipv4 family

Users report this is fixing a connection stall in:

        https://bugzilla.kernel.org/show_bug.cgi?id=203671

Thanks.
