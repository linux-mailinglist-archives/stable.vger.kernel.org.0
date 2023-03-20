Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B31E6C147C
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 15:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231693AbjCTOOz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 10:14:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231627AbjCTOOn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 10:14:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0610210427;
        Mon, 20 Mar 2023 07:14:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F140B80E96;
        Mon, 20 Mar 2023 14:14:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B1FAC433D2;
        Mon, 20 Mar 2023 14:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679321679;
        bh=IjDIoQRDKocMSpfFmpafEm600G0Xo6VJNX8CNConEtU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cOLj7rPhAYJA34rdQZ8O0jOT8wY0u7o1nN3VEqXmC/rSnLikC97ZN+MV0jygudP8y
         OsAQlKSxzk8kSDLg2fecK864vFvu0E0JxzI2RNliWgLn7IlSHk5aXModpk8lXjcl6k
         lefi4zU9ZB1NRLnH+gKjZg/eeDGUAbQV4DZoMq4E=
Date:   Mon, 20 Mar 2023 15:13:47 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Christian Brauner <brauner@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/15] xfs backports for 5.10.y (from v5.15.103)
Message-ID: <ZBhqG3pAbPZR++ae@kroah.com>
References: <20230318101529.1361673-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230318101529.1361673-1-amir73il@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 18, 2023 at 12:15:14PM +0200, Amir Goldstein wrote:
> Greg,
> 
> Following backports catch up with recent 5.15.y xfs backports.
> 
> Patches 1-3 are the backports from the previous 5.15 xfs backports
> round that Chandan requested for 5.4 [1].
> 
> Patches 4-14 are the SGID fixes that I collaborated with Leah [2].
> Christian has reviewed the backports of his vfs patches to 5.10.
> 
> Patch 15 is a fix for a build warning caused by one of the SGID fixes
> that you applied to 5.15.y.
> 
> This series has gone through the usual xfs test/review routine.

All now queued up, thanks.

greg k-h
