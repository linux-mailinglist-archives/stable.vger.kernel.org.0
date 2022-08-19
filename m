Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07A5E599A98
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 13:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348570AbiHSLQc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 07:16:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348258AbiHSLQb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 07:16:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6530FD5DF3
        for <stable@vger.kernel.org>; Fri, 19 Aug 2022 04:16:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2EC961655
        for <stable@vger.kernel.org>; Fri, 19 Aug 2022 11:16:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4EE9C433C1;
        Fri, 19 Aug 2022 11:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660907790;
        bh=VsP0nTVW4W9OuJY596tDPs60Udf0hghK/VONwvefLQQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VJiAQEY0RZws9fAqZzUCT6dIaLj9paHZdZDASsAwFBUGw6v2umbUWxwyqqnnNr+Ww
         WDDDuedtyVWMC4ditWTTfflZkvpIODSI6z7KJirG80jV/61UceB9gHSxrsBXVHC3t3
         ZPEteeGHhioTcm/Nin+M51+t+kKgJ+8U4DrlwFtw=
Date:   Fri, 19 Aug 2022 13:16:22 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     stable@vger.kernel.org, paul.gortmaker@windriver.com,
        peterz@infradead.org, bp@suse.de, jpoimboe@kernel.org
Subject: Re: [PATCH 1/3] Revert "x86/ftrace: Use alternative RET encoding"
Message-ID: <Yv9xBi/c+y093vAf@kroah.com>
References: <20220816041224.GE73154@windriver.com>
 <20220816082658.172387-1-cascardo@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816082658.172387-1-cascardo@canonical.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 05:26:56AM -0300, Thadeu Lima de Souza Cascardo wrote:
> This reverts commit 3af2ebf798c52b20de827b9dfec13472ab4a7964.

There is no commit with this id in the tree.  I think you mean e54fcb0812faebd147de72bd37ad87cc4951c68c

thanks,

greg k-h
