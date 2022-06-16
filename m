Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3A0254E12E
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 14:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376290AbiFPM4Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 08:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbiFPM4Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 08:56:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 873FE3AA74;
        Thu, 16 Jun 2022 05:56:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E43FB823A6;
        Thu, 16 Jun 2022 12:56:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89059C341C0;
        Thu, 16 Jun 2022 12:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655384181;
        bh=gwWwfgCS2L54r9bX+ixy2WdX2LY/53hWRZq1FleZTeY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mgy2Hv1dLjD6Fxiq5N6+tlK1WqRDQFCSiEtw3jtcsTZ4C6UwL8s9exgtsyp/E8nNf
         dcouGcZa2W/os8cOFj00P3sSQNrXEt0vfX6Va4CQ3NNtT4IBlgcfesodZhKBJrlntE
         EvvGPpq4/iVuUnKWaca/xjivmVJ8n3xuclRffLHA=
Date:   Thu, 16 Jun 2022 14:56:19 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     stable <stable@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: Re: Apply commit "9p: missing chunk of fs/9p: Don't update file type
 when updating file attributes" to stable
Message-ID: <YqsoczPdM3OE8lYD@kroah.com>
References: <CALP4L7TLME-ZqOBK_k-voFbiym5PdWga_1iPGTqOu8ac0=DD0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALP4L7TLME-ZqOBK_k-voFbiym5PdWga_1iPGTqOu8ac0=DD0g@mail.gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 14, 2022 at 01:51:27PM -0700, Tadeusz Struk wrote:
> Hi,
> Please apply upstream commit b577d0cd2104 ("9p: missing chunk of
> "fs/9p: Don't update file type when updating file attributes"") to
> stable versions v4.9, v4.14, v4.19, v5.4, and v5.10.
> 
> It fixes an issue found by syzbot:
> https://syzkaller.appspot.com/bug?id=7830d7214570b38391194d814a625dbbfd569eb4
> The commit applies cleanly to all the versions listed above.
> Please also add:
> Reported-by: syzbot+16342c5db3ef64c0f60a@syzkaller.appspotmail.com
> Tested-by: Tadeusz Struk <tadeusz.struk@linaro.org>

Now queued up.

greg k-h
Cc: stable <stable@kernel.org>
