Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E64FC548807
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349130AbiFMK44 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349965AbiFMKyi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:54:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E8E62FFF3;
        Mon, 13 Jun 2022 03:28:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB51460F09;
        Mon, 13 Jun 2022 10:28:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDB99C34114;
        Mon, 13 Jun 2022 10:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116110;
        bh=7xf9iBHpNNLxSetGM17NzppiizC8ZCsYKWufW33KuuU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QfTq9oaHAA6qI4b3o2mjNQRBuuIzawJTIf/6OKrGJoFQ+6LolIJkbQL3O/ZeREbpL
         eHsXb4pQIyqaWKElNd4wXN1aLgzdQr0ySoujB58miir1HwnkIDx7dtS+eUIGoGKnUh
         Bw0Gb/Wsre0DTaTx9gDVdoCZdnl8uxs/w0Xa4iOc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Akira Yokosawa <akiyks@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 4.14 134/218] docs/conf.py: Cope with removal of language=None in Sphinx 5.0.0
Date:   Mon, 13 Jun 2022 12:09:52 +0200
Message-Id: <20220613094924.647845896@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094908.257446132@linuxfoundation.org>
References: <20220613094908.257446132@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Akira Yokosawa <akiyks@gmail.com>

commit 627f01eab93d8671d4e4afee9b148f9998d20e7c upstream.

One of the changes in Sphinx 5.0.0 [1] says [sic]:

    5.0.0 final

     - #10474: language does not accept None as it value.
       The default value of language becomes to 'en' now.

[1]: https://www.sphinx-doc.org/en/master/changes.html#release-5-0-0-released-may-30-2022

It results in a new warning from Sphinx 5.0.0 [sic]:

    WARNING: Invalid configuration value found: 'language = None'.
    Update your configuration to a valid langauge code. Falling
    back to 'en' (English).

Silence the warning by using 'en'.
It works with all the Sphinx versions required for building
kernel documentation (1.7.9 or later).

Signed-off-by: Akira Yokosawa <akiyks@gmail.com>
Link: https://lore.kernel.org/r/bd0c2ddc-2401-03cb-4526-79ca664e1cbe@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/conf.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/conf.py
+++ b/Documentation/conf.py
@@ -96,7 +96,7 @@ finally:
 #
 # This is also used if you do content translation via gettext catalogs.
 # Usually you set "language" from the command line for these cases.
-language = None
+language = 'en'
 
 # There are two options for replacing |today|: either, you set today to some
 # non-false value, then it is used:


