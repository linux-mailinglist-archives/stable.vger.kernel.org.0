Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4528E5AA7F0
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 08:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235486AbiIBGQu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 02:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235476AbiIBGQr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 02:16:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 568DBA7AA2;
        Thu,  1 Sep 2022 23:16:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D984561FE5;
        Fri,  2 Sep 2022 06:16:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEA54C4314B;
        Fri,  2 Sep 2022 06:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662099400;
        bh=NF39YclY6obmzggaJWbFDoP8wUIfMBQtlsBogr57Hqc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CpyWJYh+JThuCc6bqeHD3x8k8yWRRqJBG9WplzT6oR8Qde2G2oD9QPY8r6EGVANQK
         BETW7Dhct58D8EFKOR7JIaDFU8mK0eFtl1Zxky/zcIAlUhiFm+DUZRaYZUj79heSxl
         jqUp7wS20DTXntUVjNQ8UWZUb6GIivOpVrOuD4m4=
Date:   Fri, 2 Sep 2022 08:16:37 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 5.10 v3 1/5] xfs: remove infinite loop when reserving
 free block pool
Message-ID: <YxGfxaCrKW9NUxYZ@kroah.com>
References: <20220901133356.2473299-1-amir73il@gmail.com>
 <20220901133356.2473299-2-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220901133356.2473299-2-amir73il@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 01, 2022 at 04:33:52PM +0300, Amir Goldstein wrote:
> commit 15f04fdc75aaaa1cccb0b8b3af1be290e118a7bc upstream.
> 
> [Added wrapper xfs_fdblocks_unavailable() for 5.10.y backport]

You forgot the correct Author/From: information here :(

Please be more careful next time.

greg k-h
