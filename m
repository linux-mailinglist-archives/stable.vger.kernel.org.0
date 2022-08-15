Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED2159339B
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 18:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbiHOQ4M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 12:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiHOQ4L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 12:56:11 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E2612237D4
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 09:56:05 -0700 (PDT)
Received: from sequoia (162-237-133-238.lightspeed.rcsntx.sbcglobal.net [162.237.133.238])
        by linux.microsoft.com (Postfix) with ESMTPSA id 2F69A20DDC6D;
        Mon, 15 Aug 2022 09:56:05 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2F69A20DDC6D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1660582565;
        bh=pYQ6MfbApT5ankcDy1fBJYfwlUIjORtVML28ju/Uv2A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aeRLWiN3f/QZYXG4ZnGf3eFK+VSctNoxwTV6VbptW+UHlXYehfrwed5hbFFiuHChe
         WWIv2y83SCRtpQBnIWMZd8uG47FC55GnmH6gvAuHA4dAKzDp8+xKcjUhybssVNIWeQ
         vw7JCyJ8XqZRllF11ps3KG5+xVoJs/GcEuBzColM=
Date:   Mon, 15 Aug 2022 11:55:50 -0500
From:   Tyler Hicks <tyhicks@linux.microsoft.com>
To:     asmadeus@codewreck.org
Cc:     gregkh@linuxfoundation.org, linux_oss@crudebyte.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] net/9p: Initialize the iounit field
 during fid creation" failed to apply to 5.10-stable tree
Message-ID: <20220815165550.GA39334@sequoia>
References: <1660564171201106@kroah.com>
 <YvpBSrujdzfGHPHz@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvpBSrujdzfGHPHz@codewreck.org>
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-08-15 21:51:22, asmadeus@codewreck.org wrote:
> gregkh@linuxfoundation.org wrote on Mon, Aug 15, 2022 at 01:49:31PM +0200:
> > The patch below does not apply to the 5.10-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> I guess it'd make sense, Tyler do you want to do it or shall I?

I'll take care of it today.

> Probably almost trivial with just context around the zero
> initializations you removed that changed a bit.

Yep, that's correct.

Tyler

> 
> --
> Dominique
> 
