Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF9C4EA170
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 22:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240356AbiC1UZb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 28 Mar 2022 16:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240195AbiC1UZa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 16:25:30 -0400
Received: from mail.lixid.net (lixid.tarent.de [193.107.123.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A518047563
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 13:23:48 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.lixid.net (MTA) with ESMTP id 49BAE141168;
        Mon, 28 Mar 2022 22:23:47 +0200 (CEST)
Received: from mail.lixid.net ([127.0.0.1])
        by localhost (mail.lixid.net [127.0.0.1]) (MFA, port 10024) with LMTP
        id jwEZ28_W8Mro; Mon, 28 Mar 2022 22:23:42 +0200 (CEST)
Received: from tglase-nb.lan.tarent.de (vpn-172-34-0-14.dynamic.tarent.de [172.34.0.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.lixid.net (MTA) with ESMTPS id F24B51405F8;
        Mon, 28 Mar 2022 22:23:41 +0200 (CEST)
Received: by tglase-nb.lan.tarent.de (Postfix, from userid 1000)
        id 49CD71CA194; Mon, 28 Mar 2022 22:23:41 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by tglase-nb.lan.tarent.de (Postfix) with ESMTP id 46B241CA193;
        Mon, 28 Mar 2022 22:23:41 +0200 (CEST)
Date:   Mon, 28 Mar 2022 22:23:41 +0200 (CEST)
From:   Thorsten Glaser <t.glaser@tarent.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     Vlad Buslov <vladbu@mellanox.com>, stable@vger.kernel.org,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Lee Jones <lee.jones@linaro.org>, Daniel.Fleischer@orbit.de,
        Marcel.Krause@orbit.de, christian.hampe@telekom.de,
        haye.haehne@telekom.de, keith.lloyd@telekom.de
Subject: Re: v4.19.221 breaks qdisc modules
In-Reply-To: <YkFMoe4t1dRkHlEX@kroah.com>
Message-ID: <a1467150-9f6-3e56-9b79-2249a9af45@tarent.de>
References: <919153d5-a79a-de71-9584-10179ae586d@tarent.de> <425d1b7-abb9-903c-4ae4-11f27ef06313@tarent.de> <YkFMoe4t1dRkHlEX@kroah.com>
Content-Language: de-DE-1901
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 28 Mar 2022, Greg Kroah-Hartman wrote:

> > How can I make this module compatible with *both* 4.19 variants?
> 
> Ah, external code, sorry, you are on your own.

This is… no, I’m going to have to censor my thoughts on this response.

(Besides, these are patched version of in-tree modules to experiment
with new network features.)

> As for how to test for larger numbers, see the answer in the email
> archives, others have done this successfully.
> 
> good luck!

Search engine fodder would have been welcome. All I found so far is
https://lwn.net/ml/linux-kernel/20210208145805.898658055@linuxfoundation.org/
in which you speak of mysterious “different ways of extracting the
version number” that “out of tree modules have”, I’d love to see them.

bye,
//mirabilos
-- 
Infrastrukturexperte • tarent solutions GmbH
Am Dickobskreuz 10, D-53121 Bonn • http://www.tarent.de/
Telephon +49 228 54881-393 • Fax: +49 228 54881-235
HRB AG Bonn 5168 • USt-ID (VAT): DE122264941
Geschäftsführer: Dr. Stefan Barth, Kai Ebenrett, Boris Esser, Alexander Steeg

                        ****************************************************
/⁀\ The UTF-8 Ribbon
╲ ╱ Campaign against      Mit dem tarent-Newsletter nichts mehr verpassen:
 ╳  HTML eMail! Also,     https://www.tarent.de/newsletter
╱ ╲ header encryption!
                        ****************************************************
