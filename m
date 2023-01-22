Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51B52676D0E
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 14:02:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbjAVNC1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 08:02:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbjAVNC1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 08:02:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 481D51B54E
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 05:02:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1927B80AD3
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 13:02:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F11AC433D2;
        Sun, 22 Jan 2023 13:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674392543;
        bh=RcjOXg4aKuA5TK83m0/SmZUtHkJqhnMHYgKu0irIZBg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G4MnuiWoWfJ9AvybdTDTG0e2oXSx84RnXwUFW1dhQ/sJiPALmruzJiMXoWxQx4Waq
         6qN3RkWy8bHs6A7fwxOnbpoqLLfa241T5SQ2Rae9yrJC2qC6oqpqbPZcscv5js/YmC
         TKrzOvm4fCuNO2nWoFvmxqIFzJv5+hHTIl2NduCY=
Date:   Sun, 22 Jan 2023 14:02:21 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     stable@vger.kernel.org,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        erkin.bozoglu@xeront.com
Subject: Re: Please apply ce835dbd04d7 to 5.15
Message-ID: <Y80z3SxohL8HsyfI@kroah.com>
References: <ca79114b-abb8-fd2a-4e77-36e23dbec0f4@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ca79114b-abb8-fd2a-4e77-36e23dbec0f4@arinc9.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 20, 2023 at 02:55:44PM +0300, Arınç ÜNAL wrote:
> Commit ce835dbd04d7b24f9fd50d9a9c59be46304aaa8a ("staging: mt7621-dts:
> change some node hex addresses to lower case") upstream.
> 
> Please apply this commit to 5.15. It solves the regression the kernel test
> robot has reported.
> 
> https://lore.kernel.org/all/aa73cfb8-99ed-20b4-071c-9858399aee0a@arinc9.com/T/

Now queued up, thanks.

greg k-h
