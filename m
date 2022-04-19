Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70CB750631F
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 06:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347430AbiDSEPz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 00:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbiDSEPy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 00:15:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F1225C62;
        Mon, 18 Apr 2022 21:13:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6973260FCA;
        Tue, 19 Apr 2022 04:13:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A726C385A7;
        Tue, 19 Apr 2022 04:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650341592;
        bh=uRb5B3VU5sevqwJjYnq8xWKLwj3O2yeeXaH+LNyJY4A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EEQxtoNV0x39OVlDG/JexZ2Xntf7VRvDH3ZDv2+cEM9LwBIXwynyIYL7zasns7mMi
         RvJHc315wVIjdVkS2ntMZznDwEK4iXRRRqzafoyS1FenQI5gw4diIaSIP9v0WA0j0R
         tHy9ojyQMlKUUH2GxZBQH3WjJ7rZzI5AZbrs/u5Q=
Date:   Mon, 18 Apr 2022 21:13:11 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Steve Capper <steve.capper@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v10] mm, hugetlbfs: Allow for "high" userspace addresses
Message-Id: <20220418211311.1521c61e57367dfb1614287d@linux-foundation.org>
In-Reply-To: <f9d7a5ef-640f-8982-894e-46d823e32b4a@csgroup.eu>
References: <ab847b6edb197bffdfe189e70fb4ac76bfe79e0d.1650033747.git.christophe.leroy@csgroup.eu>
        <20220415151244.c29ad0c9c481dab0ade1022b@linux-foundation.org>
        <f9d7a5ef-640f-8982-894e-46d823e32b4a@csgroup.eu>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-10.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 16 Apr 2022 06:29:04 +0000 Christophe Leroy <christophe.leroy@csgro=
up.eu> wrote:

>=20
>=20
> Le 16/04/2022 =E0 00:12, Andrew Morton a =E9crit=A0:
> > On Fri, 15 Apr 2022 16:45:13 +0200 Christophe Leroy <christophe.leroy@c=
sgroup.eu> wrote:
> >=20
> >> This is a fix for commit f6795053dac8 ("mm: mmap: Allow for "high"
> >> userspace addresses") for hugetlb.
> >=20
> > So the "hugetlbfs" in the Subject: is a tpyo?
>=20
> This patch modifies fs/hugetlbfs/inode.c , hence the "hugetlbfs" in the=20
> Subject.

Sorry, obviously I was too sober at the time.

