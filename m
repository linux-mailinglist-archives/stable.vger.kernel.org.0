Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE0C061F0BB
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 11:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbiKGKd4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 05:33:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbiKGKdw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 05:33:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD47B273B;
        Mon,  7 Nov 2022 02:33:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DF7160FBA;
        Mon,  7 Nov 2022 10:33:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9FBAC433D6;
        Mon,  7 Nov 2022 10:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667817228;
        bh=xMmwTKgR8xLv7D04js/Rsm1kq7uL9UsHHojenyPZTeU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WriRVPK6jCgwq0iia9J5qANNqDfT/vbLN3rLaezsJL95JRMRaEeLvqa5CTqYs0KlF
         657Xnf6DBkkRdAxCIEF+2O0Ztjakt8B3kkXaf8f2Cj/I/9d2kMCEV/i4tCHOt7fqE6
         ju3CqWZaT5zXCUlG5lNM9OLz0wCnDer+mKM5iqrBTThtlXpK4NSR1AaPz0KXVfjm2m
         g8UuhojD3yCtFkaOegtZkihpAnBJEhL4Xbljnnyizd1jE9+IxXz7EZGRWagiPsGik6
         imaoqukvWyPbK08pt2eY28kTt77HUi/89g5W/G9Lib/nU9ughrZKw1V4wGfD9hHMY6
         SbF9J2AQmCc2w==
Date:   Mon, 7 Nov 2022 10:33:43 +0000
From:   Lee Jones <lee@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     Frank Rowand <frowand.list@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] scripts/dtc: Update to upstream version
 v1.6.1-63-g55778a03df61
Message-ID: <Y2jfB2YErvi+EIvN@google.com>
References: <20221101181427.1808703-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221101181427.1808703-1-robh@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 01 Nov 2022, Rob Herring wrote:

> It's been a while since the last sync and Lee needs commit 73590342fc85
> ("libfdt: prevent integer overflow in fdt_next_tag").
> 
> This adds the following commits from upstream:
> 
> 55778a03df61 libfdt: tests: add get_next_tag_invalid_prop_len
> 73590342fc85 libfdt: prevent integer overflow in fdt_next_tag
> 035fb90d5375 libfdt: add fdt_get_property_by_offset_w helper
> 98a07006c48d Makefile: fix infinite recursion by dropping non-existent `%.output`
> a036cc7b0c10 Makefile: limit make re-execution to avoid infinite spin
> c6e92108bcd9 libdtc: remove duplicate judgments
> e37c25677dc9 Don't generate erroneous fixups from reference to path
> 50454658f2b5 libfdt: Don't mask fdt_get_name() returned error
> e64a204196c9 manual.txt: Follow README.md and remove Jon
> f508c83fe6f0 Update README in MANIFEST.in and setup.py to README.md
> c2ccf8a77dd2 Add description of Signed-off-by lines
> 90b9d9de42ca Split out information for contributors to CONTRIBUTING.md
> 0ee1d479b23a Remove Jon Loeliger from maintainers list
> b33a73c62c1c Convert README to README.md
> 7ad60734b1c1 Allow static building with meson
> fd9b8c96c780 Allow static building with make
> fda71da26e7f libfdt: Handle failed get_name() on BEGIN_NODE
> c7c7f17a83d5 Fix test script to run also on dash shell
> 01f23ffe1679 Add missing relref_merge test to meson test list
> ed310803ea89 pylibfdt: add FdtRo.get_path()
> c001fc01a43e pylibfdt: fix swig build in install
> 26c54f840d23 tests: add test cases for label-relative path references
> ec7986e682cf dtc: introduce label relative path references
> 651410e54cb9 util: introduce xstrndup helper
> 4048aed12b81 setup.py: fix out of tree build
> ff5afb96d0c0 Handle integer overflow in check_property_phandle_args()
> ca7294434309 README: Explain how to add a new API function
> c0c2e115f82e Fix a UB when fdt_get_string return null
> cd5f69cbc0d4 tests: setprop_inplace: use xstrdup instead of unchecked strdup
> a04f69025003 pylibfdt: add Property.as_*int*_array()
> 83102717d7c4 pylibfdt: add Property.as_stringlist()
> d152126bb029 Fix Python crash on getprop deallocation
> 17739b7ef510 Support 'r' format for printing raw bytes with fdtget
> 45f3d1a095dd libfdt: overlay: make overlay_get_target() public
> c19a4bafa514 libfdt: fix an incorrect integer promotion
> 1cc41b1c969f pylibfdt: Add packaging metadata
> db72398cd437 README: Update pylibfdt install instructions
> 383e148b70a4 pylibfdt: fix with Python 3.10
> 23b56cb7e189 pylibfdt: Move setup.py to the top level
> 69a760747d8d pylibfdt: Split setup.py author name and email
> 0b106a77dbdc pylibfdt: Use setuptools_scm for the version
> c691776ddb26 pylibfdt: Use setuptools instead of distutils
> 5216f3f1bbb7 libfdt: Add static lib to meson build
> 4eda2590f481 CI: Cirrus: bump used FreeBSD from 12.1 to 13.0

At least one of these patches fixes security concerns.

Could we also have this in Stable please?

> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  scripts/dtc/checks.c               | 15 +++++++-----
>  scripts/dtc/dtc-lexer.l            |  2 +-
>  scripts/dtc/dtc-parser.y           | 13 ++++++++++
>  scripts/dtc/libfdt/fdt.c           | 20 +++++++++------
>  scripts/dtc/libfdt/fdt.h           |  4 +--
>  scripts/dtc/libfdt/fdt_addresses.c |  2 +-
>  scripts/dtc/libfdt/fdt_overlay.c   | 29 ++++++----------------
>  scripts/dtc/libfdt/fdt_ro.c        |  2 +-
>  scripts/dtc/libfdt/libfdt.h        | 25 +++++++++++++++++++
>  scripts/dtc/livetree.c             | 39 +++++++++++++++++++++++++++---
>  scripts/dtc/util.c                 | 15 ++++++++++--
>  scripts/dtc/util.h                 |  4 ++-
>  scripts/dtc/version_gen.h          |  2 +-
>  13 files changed, 124 insertions(+), 48 deletions(-)

-- 
Lee Jones [李琼斯]
