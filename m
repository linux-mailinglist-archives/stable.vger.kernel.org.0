Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 498205EF468
	for <lists+stable@lfdr.de>; Thu, 29 Sep 2022 13:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235337AbiI2Lgg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Sep 2022 07:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235320AbiI2Lge (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Sep 2022 07:36:34 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7356013D1DB;
        Thu, 29 Sep 2022 04:36:33 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 28TBaKDZ022953
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Sep 2022 07:36:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1664451381; bh=AdtewCAf9XNJr9bFIHpIke2+G5PbSnpa1S/HqBIX9dY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=MSPsXOzbnuaTlYMxq6au6RnbGj7vyCrUzNWhPRl7UaDJbkmhinbvonmwZoNdtcTUX
         PNC7Unuh3UBRGua3NbASM7Ag6Vqs5eusq2t0wrTC6oHl8KGFo7taZ4OZffO7fcDKs8
         woKTkrLcFdxdr+dfo1ISBXvvobw1PyMIHLMV87/U8eSXRVCJMmPmEt3n/xgPyqSd4x
         NDaEAKUZjF+zTA68VKIlSxs553pxfhDev9kii6GUVpkuUqZZoWwL+kxSVgM1zai+SZ
         z7oHo+WcnaTl2ma490gox3//1spNnhqEN21Yor0zdIgQIgVytx8vEZTh1XADKVRdSi
         Wms027zlnVb2w==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 0BD3715C00C9; Thu, 29 Sep 2022 07:36:20 -0400 (EDT)
Date:   Thu, 29 Sep 2022 07:36:20 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: significant drop fio IOPS performance on v5.10 #forregzbot
Message-ID: <YzWDNDw+++S+9272@mit.edu>
References: <357ace228adf4e859df5e9f3f4f18b49@amazon.com>
 <1cdc68e6a98d4e93a95be5d887bcc75d@amazon.com>
 <5c819c9d6190452f9b10bb78a72cb47f@amazon.com>
 <9e3a4bf9-c909-d6aa-28c8-5fbbea9f5ae3@leemhuis.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e3a4bf9-c909-d6aa-28c8-5fbbea9f5ae3@leemhuis.info>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a repeat of a discussion regarding changing the default of
dioread_nolock.  Note that you can "revert" this change in defaults by
using the mount options "nodioread_nolock" (or "dioread_lock").  There
were some good reasons why the change in the default was made, though.

#regzbot invalid: caused by a change of defaults that (among others) was
done for security reasons, see Ted's answer in
https://lore.kernel.org/all/Yypx6VQRbl3bFP2v@mit.edu/ for details

					- Ted
