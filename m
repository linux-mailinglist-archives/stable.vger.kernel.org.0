Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7491D4FA970
	for <lists+stable@lfdr.de>; Sat,  9 Apr 2022 18:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242574AbiDIQMQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Apr 2022 12:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbiDIQMQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Apr 2022 12:12:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11DF51B7BD
        for <stable@vger.kernel.org>; Sat,  9 Apr 2022 09:10:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A20DD60B59
        for <stable@vger.kernel.org>; Sat,  9 Apr 2022 16:10:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4CF6C385A0;
        Sat,  9 Apr 2022 16:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649520608;
        bh=9n37BCAnP9tbVchh15xt1oK09uY/QxC/BwTzR4NTOb8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uuZ+9wTfr0gjTepL4foqVoAWhB3MHShVw0jNlcbek6BAn5pl4TaEWOKwVhsYkJLvy
         pEYh/qVScqdoUBJvrIP/K00UGms+oFxCO3dWP9cIeqhGzTnc++GWISQvsNVf9exIf+
         jVMupQfhUDu2qLGZ1nJBBNAtqRCCWKR9TeBlQsdO5887mSktVveyE5IGVESyNAfT3J
         suombIs/jj2m+T9c3N2HOXm/KMNyalNKa2LOcb+wQy8/Esr2jk8C+aaf4SjaZjLfzW
         +70P/3A6Dr1Do+iFEkXEaG1mjTpqAU/JKLBZErhOzAZtdcJgXtPbo9F74iuLPiVvq9
         mNxXKBsUKrnmw==
Date:   Sat, 9 Apr 2022 12:10:06 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Mauricio Faria de Oliveira <mfo@canonical.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 0/1] mm: fix race between MADV_FREE reclaim and blkdev
 direct IO
Message-ID: <YlGv3jw75TKkD50w@sashalap>
References: <20220407191432.1456219-1-mfo@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220407191432.1456219-1-mfo@canonical.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 07, 2022 at 04:14:24PM -0300, Mauricio Faria de Oliveira wrote:
>commit 6c8e2a256915a223f6289f651d6b926cd7135c9e upstream.
>
>Backports for stable:
>
>- folio/page differences on 5.17, 5.16, 5.15, 5.10, 5.4, 4.19;
>- context lines differences on 4.14;
>- conditional/gate differences on 4.9;
>(changes described in each commit.)
>
>Test-case with good results on all versions
>(consistent values read on good/bad binary).
>
>Links:
>- FAILED: patch "[PATCH] mm: fix race between MADV_FREE reclaim and blkdev direct IO"
>  failed to apply to <version>-stable tree
>  - 5.17 https://lore.kernel.org/stable/1648897548136182@kroah.com/
>  - 5.16 https://lore.kernel.org/stable/164889755413570@kroah.com/
>  - 5.15 https://lore.kernel.org/stable/1648897560105145@kroah.com/
>  - 5.10 https://lore.kernel.org/stable/1648897566131152@kroah.com/
>  - 5.4  https://lore.kernel.org/stable/1648897573389@kroah.com/
>  - 4.19 https://lore.kernel.org/stable/1648897585112208@kroah.com/
>  - 4.14 https://lore.kernel.org/stable/1648897579250122@kroah.com/

Queued up, thanks!

-- 
Thanks,
Sasha
