Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67CF16D0FA0
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 22:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbjC3UES (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 16:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjC3UEQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 16:04:16 -0400
Received: from smtp29.i.mail.ru (smtp29.i.mail.ru [95.163.41.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 339A4FF3A;
        Thu, 30 Mar 2023 13:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mail.ru; s=mail4;
        h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:From:Subject:Content-Type:Content-Transfer-Encoding:To:Cc; bh=/KwLuyN6DA3WQCEt1mqpLUJneHLTOrAEdF6ccXR5Q4M=;
        t=1680206653;x=1680296653; 
        b=yybo5W6KA2FYCJFmOJtOHkscN4BqhufYhSX9UuPcyy7zX46cnir9FIAg1IGoBCt7p3j/X38IZQS0E9kWBEPamypdRnVxTSloImHkYMBluQyVlDXnuljwBsTCfVXSmEFLA8SBJ2cGYPVCFFJOxGvppbf9t6P1dawQV2G7h9/JYMbtFuhftvusOeN7rJsfMb+VYFuJh4L6rbDgf1rbVYBvP2Hxj6Z4ef/BNqj3LswNFw2bRgAm4eZMW79FL4YgiBVXxwshZk7E8HUPSTAdDM0m9u+ysRIwCI38+2Kmr3VcvXpLPh7/vP67FqqTHeJVlqcfTssx9kvww1250OyVjGY1gA==;
Received: by smtp29.i.mail.ru with esmtpa (envelope-from <listdansp@mail.ru>)
        id 1phyVG-00DNfA-IX; Thu, 30 Mar 2023 23:04:11 +0300
From:   Danila Chernetsov <listdansp@mail.ru>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Danila Chernetsov <listdansp@mail.ru>,
        Dinghao Liu <dinghao.liu@zju.edu.cn>,
        linux-staging@lists.linux.dev, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org
Subject: 
Date:   Thu, 30 Mar 2023 20:01:12 +0000
Message-Id: <20230330200112.17334-2-listdansp@mail.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230330200112.17334-1-listdansp@mail.ru>
References: <20230330200112.17334-1-listdansp@mail.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp29.i.mail.ru; auth=pass smtp.auth=listdansp@mail.ru smtp.mailfrom=listdansp@mail.ru
X-Mailru-Src: smtp
X-7564579A: B8F34718100C35BD
X-77F55803: 4F1203BC0FB41BD9381BDEF7E8905223B336BEBABBA06DCCB6C010CA664C617B182A05F538085040055460C9F9F4C7E84C69273D6CF731E78A24368A4DEAECE1A3B75102AD07AABE
X-7FA49CB5: FF5795518A3D127A4AD6D5ED66289B5278DA827A17800CE7F8E53417176C7207EA1F7E6F0F101C67BD4B6F7A4D31EC0BCC500DACC3FED6E28638F802B75D45FF8AA50765F79006370D3D68FCEFFDD9EA8638F802B75D45FF36EB9D2243A4F8B5A6FCA7DBDB1FC311F39EFFDF887939037866D6147AF826D8079BDFF25075ECCA8D573CB2C456DE5B6F9789CCF6C18C3F8528715B7D10C86878DA827A17800CE754B4581DB7A805049FA2833FD35BB23D9E625A9149C048EED76C6ED7039589DE2CC0D3CB04F14752D2E47CDBA5A96583BD4B6F7A4D31EC0BC014FD901B82EE079FA2833FD35BB23D27C277FBC8AE2E8B8C81B5738AFAA7AFA471835C12D1D977C4224003CC836476EB9C4185024447017B076A6E789B0E975F5C1EE8F4F765FC372E3A6649EBCBD43AA81AA40904B5D9CF19DD082D7633A078D18283394535A93AA81AA40904B5D98AA50765F7900637EFEE248DCEC35FEAD81D268191BDAD3D3666184CF4C3C14F3FC91FA280E0CE3D1A620F70A64A45A98AA50765F79006372E808ACE2090B5E1725E5C173C3A84C3C5EA940A35A165FF2DBA43225CD8A89FD2A95C73FD1EFF45156CCFE7AF13BCA4B5C8C57E37DE458BEDA766A37F9254B7
X-C1DE0DAB: 0D63561A33F958A57A6FACF6CF5F58C295AB441B7CAD1C792A035B3176775108F87CCE6106E1FC07E67D4AC08A07B9B065B78C30F681404D9C5DF10A05D560A950611B66E3DA6D700B0A020F03D25A09D2DCF9CF1F528DBCCB5012B2E24CD356
X-C8649E89: 1C3962B70DF3F0ADE00A9FD3E00BEEDF77DD89D51EBB7742D3581295AF09D3DF87807E0823442EA2ED31085941D9CD0AF7F820E7B07EA4CF7CDC0AFB2DCF4D6E1C143BF23ECC15248921A390DB9F2E5B3820F40037AA6562506ED036F265C54262C9293813A964D64CD6C86F4A14489AA71E3722AA2B854B32947E98E9153962
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5ycPtXkTV4k65bRjmOUUP8cvGozZ33TWg5HZplvhhXbhDGzqmQDTd6OAevLeAnq3Ra9uf7zvY2zzsIhlcp/Y7m53TZgf2aB4JOg4gkr2biojoVQ5iBoMj9aHkKk/O5302w==
X-Mailru-Sender: F244DC1430FACE54496B7D2C616565FD20DF740DC15E9CD31FE56E1E0160025364D1AAD6AE5DFCABCE8DDCF05647143DC77752E0C033A69E3DC0BC7494A416CF0226C39053983FF0B4A721A3011E896F
X-Mras: Ok
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Date: Thu, 30 Mar 2023 18:44:28 +0000
Subject: [PATCH 5.10 1/1] staging: rtl8192u: Add null check in
 rtl8192_usb_initendpoints

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

commit 4d5f81506835f7c1e5c71787bed84984faf05884 upstream.

There is an allocation for priv->rx_urb[16] has no null check,
which may lead to a null pointer dereference.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Link: https://lore.kernel.org/r/20201226080258.6576-1-dinghao.liu@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Danila Chernetsov <listdansp@mail.ru>
---
 drivers/staging/rtl8192u/r8192U_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 7f90af8a7c7c..e0fec7d172da 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -1608,6 +1608,8 @@ static short rtl8192_usb_initendpoints(struct net_device *dev)
 		void *oldaddr, *newaddr;
 
 		priv->rx_urb[16] = usb_alloc_urb(0, GFP_KERNEL);
+		if (!priv->rx_urb[16])
+			return -ENOMEM;
 		priv->oldaddr = kmalloc(16, GFP_KERNEL);
 		if (!priv->oldaddr)
 			return -ENOMEM;
-- 
2.25.1

