Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3557592F38
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 14:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242540AbiHOMvr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 08:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232184AbiHOMvq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 08:51:46 -0400
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 663DA14D0F
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 05:51:45 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id C86EEC01C; Mon, 15 Aug 2022 14:51:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1660567902; bh=MRU1HzK2HWcF04LgGp5oR6IOEl0VjZgwMEES61Q7A9s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i72hrfBsCP1plPHX+Hox7P1hmNFVIzuH9pFzCsq10t/FtwBpcZxA/D1HxF+3a7cs9
         ZKM90IBCiAqhN6Zyoena/Wb4GBP6N4HizyUBE1J9O5CMwn1XE6PLkod4905yUpws98
         1Fj3xIuDhKKHxkNq1ljcZqfpITtvW/xxiy523CHUQ50itFYhzY7QxWRtb9EfNp8muD
         yJHNbVVGLj+Mo5JnobzsVz9Q7KSEtaTeNM6xq7OpkY2XrW/0oi4Pzux9mk9dcMWGv9
         wWwyp/BKQ+7sP5SOesAfMZW+dHueSwupcpj1ki21+W9yc67AYG7lngTeSdB5guij8B
         S76NI0m1DtGsQ==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 178F7C009;
        Mon, 15 Aug 2022 14:51:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1660567902; bh=MRU1HzK2HWcF04LgGp5oR6IOEl0VjZgwMEES61Q7A9s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i72hrfBsCP1plPHX+Hox7P1hmNFVIzuH9pFzCsq10t/FtwBpcZxA/D1HxF+3a7cs9
         ZKM90IBCiAqhN6Zyoena/Wb4GBP6N4HizyUBE1J9O5CMwn1XE6PLkod4905yUpws98
         1Fj3xIuDhKKHxkNq1ljcZqfpITtvW/xxiy523CHUQ50itFYhzY7QxWRtb9EfNp8muD
         yJHNbVVGLj+Mo5JnobzsVz9Q7KSEtaTeNM6xq7OpkY2XrW/0oi4Pzux9mk9dcMWGv9
         wWwyp/BKQ+7sP5SOesAfMZW+dHueSwupcpj1ki21+W9yc67AYG7lngTeSdB5guij8B
         S76NI0m1DtGsQ==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 06c82f52;
        Mon, 15 Aug 2022 12:51:37 +0000 (UTC)
Date:   Mon, 15 Aug 2022 21:51:22 +0900
From:   asmadeus@codewreck.org
To:     tyhicks@linux.microsoft.com
Cc:     gregkh@linuxfoundation.org, linux_oss@crudebyte.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] net/9p: Initialize the iounit field
 during fid creation" failed to apply to 5.10-stable tree
Message-ID: <YvpBSrujdzfGHPHz@codewreck.org>
References: <1660564171201106@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1660564171201106@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

gregkh@linuxfoundation.org wrote on Mon, Aug 15, 2022 at 01:49:31PM +0200:
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

I guess it'd make sense, Tyler do you want to do it or shall I?

Probably almost trivial with just context around the zero
initializations you removed that changed a bit.

--
Dominique
