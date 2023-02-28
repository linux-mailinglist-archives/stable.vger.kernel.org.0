Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79F9E6A5EEC
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 19:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbjB1Soa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Feb 2023 13:44:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjB1Soa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Feb 2023 13:44:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12ED9272C;
        Tue, 28 Feb 2023 10:44:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1500B80EAA;
        Tue, 28 Feb 2023 18:44:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F8D2C433D2;
        Tue, 28 Feb 2023 18:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677609866;
        bh=Ff3CVg5SKpQTgjMgVjQBixgNqntUfzTQdpFfBosp8hk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wcENlY6TchymH4KXJfHxghSlXBY1fGbu0+h7hwpcyMOOQC2AxmnF+J5Ajkjk9JV3l
         sbz4n3mKBNhzAUMKF4Qs3p2o6+o8Q1TU1EAqgQR+o50vEzeAbXUJlDzsXsNW6h89v1
         /RACziwHhV5m2TDiRbbKwJKphRiOzeJlGAzfHqjM=
Date:   Tue, 28 Feb 2023 19:44:21 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 6.1 0/5] Backport v6.2 SGID fixes to LTS 6.1
Message-ID: <Y/5LhTVMwLETrmlj@kroah.com>
References: <20230223152044.1064909-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230223152044.1064909-1-amir73il@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 23, 2023 at 05:20:39PM +0200, Amir Goldstein wrote:
> Greg,
> 
> Following are backports of Christian's SGID fixes that were merged to
> v6.2-rc1.
> 
> Note that Christain's PR [1] contains also two ovl patches (from me).
> Those two are independent fixes that have already been AUTOSELected
> to 6.1.y.
> 
> Christain's fixes also contain a user observable change of behavior
> to fix inconsistencies of behavior between chmod/chown and write.
> This change is best described in Christain's commit to fix the expected
> behavior in xfstests [2].
> 
> It is hoped that no applications rely on this minor behavioral
> difference, and if we are wrong, we may need to party revert the
> change, but in any case, we prefer the behavior of LTS kernels to be
> consitent with that of upstream.
> 
> I ran the relevant fstests test groups on xfs and on overlayfs over xfs.
> 
> I also have backports that I prepared for 5.15 and 5.10, but those
> backports include also xfs SGID fixes, so those need to go through the
> xfs stable review process.

All now queued up, thanks.

greg k-h
