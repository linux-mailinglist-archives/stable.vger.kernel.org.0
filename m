Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1E265A3F8B
	for <lists+stable@lfdr.de>; Sun, 28 Aug 2022 21:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbiH1Tyk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Aug 2022 15:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiH1Tyj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Aug 2022 15:54:39 -0400
X-Greylist: delayed 546 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 28 Aug 2022 12:54:38 PDT
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13D1F31ECE;
        Sun, 28 Aug 2022 12:54:38 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 4DF077FCE4;
        Sun, 28 Aug 2022 19:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1661715930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=c1GnML3j8GnCzvibVWem1GantmfMAVqkhuoo9osZMW4=;
        b=ZSpPtzxBjqR4FxY/qZLxDeExNZiTBFBtSAwWAHmKf/Sco8+mMMZnJgP7L71SLeob2vUcsl
        bBnK3xmShzyAL3FnxqaGFXdmxSTEYlssSTmUETcgF795ALHc15GbKfPS/mftVILty8FfIn
        28YtNFBGr92MwGhkc3v7fpy0NPgHLRLvWjZnSPf5d3fNzTiGEbgDO19/vTIcLv6A+IZqhs
        nRT91J0sS1q4RvQV/s45YfWsXlEvDF+N/OnWK7tF9l3pqPqhEYT54HvbQglqI7hCpBUkAO
        IzP2tPFLfwnMtiTntyf/KiotyA/pmBB6RkbbVoLSk9tw3iKj8KJx6GHfIhuL8A==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-cifs@vger.kernel.org,
        Steve French <smfrench@gmail.com>
Subject: cifs backport request
Date:   Sun, 28 Aug 2022 16:45:53 -0300
Message-ID: <87r110nocu.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Could you please pick these commits for >= linux-5.7.y

        ef605e868212 ("cifs: skip trailing separators of prefix paths")
        ee3c8019cce2 ("cifs: fix uninitialized pointer in error case in dfs_cache_get_tgt_share")

as part of a fix for

	bacd704a95ad ("cifs: handle prefix paths in reconnect")
