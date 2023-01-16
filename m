Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1108C66CDB2
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234940AbjAPRiN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:38:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235038AbjAPRhl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:37:41 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B478D4995F
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:14:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=GsEYU31uPgITeejODev3lyT2zUtc5JdTy1BZ27nlYCc=;
        t=1673889280; x=1675098880; b=HNq+TB2fageLSsA1gVm+tE3rPPjlzCbnfEB0b4kD6XNlTNt
        Ch3Jjq4S8VWkkadpURcFE/gc9HN29mWOoUh1Fuo4bYI/zNSPoYqAQZcqE0wIuwhrmb7cH+fkr1BRp
        m1uVTGZEGHo3LOT4srBEndYZ48X0OgJZaJHzsOx699cMmQTyLbbLv30kc5WrYgwizIzKeCKrkYSwj
        llosDnvsQ/01hSllyENSai3pBHG8zqOIVFIkNmwSBu6d5Jz/uNR4Ft0Mf8gnc4U644+/odVObirgq
        RQFANvCnK5ZVBabcJXl/NY5xIbGr9hYLujRbtseQSlhlEQYL7dTn3cS2/TIcHtJg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pHT48-003iXM-21;
        Mon, 16 Jan 2023 18:14:36 +0100
Message-ID: <eddd4836e1f1835ea887ed91e49bb5e6ab65395f.camel@sipsolutions.net>
Subject: Re: [PATCH 4.14 097/338] wifi: mac80211: fix memory leak in
 ieee80211_if_add()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Cc:     "patches@lists.linux.dev" <patches@lists.linux.dev>,
        Zhengchao Shao <shaozhengchao@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Date:   Mon, 16 Jan 2023 18:14:35 +0100
In-Reply-To: <20230116154825.125747074@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
         <20230116154825.125747074@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2023-01-16 at 15:49 +0000, Greg Kroah-Hartman wrote:
> From: Zhengchao Shao <shaozhengchao@huawei.com>
>=20
> [ Upstream commit 13e5afd3d773c6fc6ca2b89027befaaaa1ea7293 ]
>=20
> When register_netdevice() failed in ieee80211_if_add(), ndev->tstats
> isn't released. Fix it.
>=20

Please drop this wherever you still can - we just reverted it because it
was actually based on broken analysis.

johannes
