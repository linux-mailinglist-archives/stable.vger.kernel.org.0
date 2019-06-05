Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 917D936369
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 20:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbfFESgf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jun 2019 14:36:35 -0400
Received: from mx08-00252a01.pphosted.com ([91.207.212.211]:55266 "EHLO
        mx08-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726280AbfFESgf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jun 2019 14:36:35 -0400
Received: from pps.filterd (m0102629.ppops.net [127.0.0.1])
        by mx08-00252a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x55IWTBF021145
        for <stable@vger.kernel.org>; Wed, 5 Jun 2019 19:36:33 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raspberrypi.org; h=subject : to :
 cc : references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp;
 bh=DIJyHhNCaZQSZYcs7LLYBtG2iHyAcvDRRmeZjUyduZM=;
 b=4G26pCXrYgSjJR/GDFZWYvQN1tWMijDsxIqW5s+0i6hmTcWJaKdH4NGVlRxdYUj88Qpk
 buvQu3kzEBbHdrGkgZJKbWozNf/7Tg1QZxmmdpFXks2IJpp4SSsnSWTLM/iPHsW1Hw6O
 2pXlgcdT2YJZQU3TnAsm0IsoYcqbZJXSnhbGol0RR3Nq15dtSzvgC+FgBrIDdSTBLy/o
 JzrKNei2B2DHcBL5m5VPIb65JcArw5NO9jPmAEs8lXEovdqVp1BJNMFtBZZbKKhRYywQ
 Es8zy5QjmlMhTkEJPcQTm6ITuc3llAy5HdwB8Spw8PBWNf+u5jIoR7TC0mFpDRXXx/sG nw== 
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        by mx08-00252a01.pphosted.com with ESMTP id 2suduj2bbc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <stable@vger.kernel.org>; Wed, 05 Jun 2019 19:36:33 +0100
Received: by mail-wr1-f72.google.com with SMTP id a7so2009742wro.9
        for <stable@vger.kernel.org>; Wed, 05 Jun 2019 11:36:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=raspberrypi.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=DIJyHhNCaZQSZYcs7LLYBtG2iHyAcvDRRmeZjUyduZM=;
        b=El+5UISEkkT12cdIMzUZgECUdaKAbTHrupyubd4AcHbJBhK9A4njJSMcigOk8QNK49
         NXo7sZzQCd6qVxqH9U+JZxvCxXSO+dDMXM9acmdRwu+0IwgVPw2IeAyJ5NV6R3pcjSOB
         fqYAa+l1FNT+d+niilQyQeOciHHps6S1rqUPwLMhs11driUqG/gzZGfgXNhts8La1Qw/
         v0H4yBCWTwbV8JtbsaU0A356rUbl5yw67BwRY5oApk2kCSjp4uSTXhH8TDzsQ23//8lN
         eN1zcOuINz39qUbPj2ZCzdIS4t+lpPj8srnVQOrbD/h19DUnbMQIDRuqrKpGb/sgw8zw
         PnCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=DIJyHhNCaZQSZYcs7LLYBtG2iHyAcvDRRmeZjUyduZM=;
        b=LPjQHBVJzAl9rfhyyB5jOtXf8fUXoF/X7OQOSdVweY1k0Do8GixSi2Bfpteu7wmOq8
         j2CZXNaKxsre6+1vWajbyT0fqQ0sUOIYfyqZUVUFVcITZpues2QnWI3gXhaUo3LX+XRY
         qPZWxK50cfZ7ivq9cinP5mM+6vbe4JZHgcl9nR0Fe8zDySZldyJtJbvYC9xyQoiV0F0T
         UoDE+WhcE3yXdRAYdQ/rXWrYXeWOjnzHsDkM2dFf6oHojWvErmnRSpvgiBOnVsp9YhFr
         gmRbQA8hczG/HpmD80X4rBozA1b4/+KAYtBECbTJ7TaD/AWMJ3SSHL46O0ynPGss7wXb
         MI9w==
X-Gm-Message-State: APjAAAUwBbon2shinrN4WgX2UNf98lUjnTTRSat/OYodt4qROW8AZxZ8
        738Bm76X/GkNeSAwkF6M+evKjXRl6LlTjSb1e0iiSWaQooDJfqU6qNdklJHpCVUNBLXcGUcH1z/
        q14Fh2QelxzVFjg1L
X-Received: by 2002:adf:eb09:: with SMTP id s9mr25609327wrn.127.1559759791890;
        Wed, 05 Jun 2019 11:36:31 -0700 (PDT)
X-Google-Smtp-Source: APXvYqye1dQxwKUcUuiMJgkwNiP7cgN5N4h4lqClcteKahwV+htVUEjDjyEQPUh3HC1ecQL7kb9jxw==
X-Received: by 2002:adf:eb09:: with SMTP id s9mr25609310wrn.127.1559759791567;
        Wed, 05 Jun 2019 11:36:31 -0700 (PDT)
Received: from PhilsPB.local (cpc129774-papw8-2-0-cust832.know.cable.virginm.net. [86.12.207.65])
        by smtp.gmail.com with ESMTPSA id p2sm13237547wrx.90.2019.06.05.11.36.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Jun 2019 11:36:30 -0700 (PDT)
Subject: Re: Dynamic overlay failure in 4.19 & 4.20
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <45e99a24-efb9-5473-2e57-14411537dc9f@raspberrypi.org>
 <2da582d1-11eb-3680-33f2-3a5c139613a8@raspberrypi.org>
 <20190605175059.GA29747@kroah.com>
From:   Phil Elwell <phil@raspberrypi.org>
Message-ID: <bb1ca47b-4ba3-8fcd-a859-993027c78f91@raspberrypi.org>
Date:   Wed, 5 Jun 2019 19:36:29 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190605175059.GA29747@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-05_11:,,
 signatures=0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05/06/2019 18:50, Greg Kroah-Hartman wrote:
> On Wed, Jun 05, 2019 at 01:02:18PM +0100, Phil Elwell wrote:
>> Hi,
>>
>> I think patch f96278810150 ("of: overlay: set node fields from
>> properties when add new overlay node") should be back-ported to 4.19,
>> for the reasons outlined below (briefly: without it, overlay fragments
>> that define phandles will appear to merged successfully, but they do
>> so without those phandles, causing any references to them to break).
> 
> That patch does not properly apply to the 4.19.y tree.  Can you provide
> a working backport that I can queue up to resolve this?
> 
> thanks,
> 
> greg k-h
> 

Yes, of course:

----

 From 714e9cd6d2ceb7716bcc60e86c540f9e9b5e76f0 Mon Sep 17 00:00:00 2001
From: Frank Rowand <frank.rowand@sony.com>
Date: Fri, 12 Oct 2018 19:21:16 -0700
Subject: [PATCH] of: overlay: set node fields from properties when add new
  overlay node

commit f96278810150fc39085d1872e5b39ea06366d03e upstream.

Overlay nodes added by add_changeset_node() do not have the node
fields name, phandle, and type set.

The node passed to __of_attach_node() when the add node changeset
entry is processed does not contain any properties.  The node's
properties are located in add property changeset entries that will
be processed after the add node changeset is applied.

Set the node's fields in the node contained in the add node
changeset entry and do not set them to incorrect values in
add_changeset_node().

A visible symptom that is fixed by this patch is the names of nodes
added by overlays that have an entry in /sys/bus/platform/drivers/*/
will contain the unit-address but the node-name will be <NULL>,  for
example, "fc4ab000.<NULL>".  After applying the patch the name, in
this example, for node restart@fc4ab000 is "fc4ab000.restart".

Tested-by: Alan Tull <atull@kernel.org>
Signed-off-by: Frank Rowand <frank.rowand@sony.com>
---
  drivers/of/dynamic.c | 27 ++++++++++++++++++---------
  drivers/of/overlay.c | 34 +++++++++++++++++++++++++++-------
  2 files changed, 45 insertions(+), 16 deletions(-)

diff --git a/drivers/of/dynamic.c b/drivers/of/dynamic.c
index 45c0b1f..a09c1c3 100644
--- a/drivers/of/dynamic.c
+++ b/drivers/of/dynamic.c
@@ -205,15 +205,24 @@ static void __of_attach_node(struct device_node *np)
  	const __be32 *phandle;
  	int sz;
  
-	np->name = __of_get_property(np, "name", NULL) ? : "<NULL>";
-	np->type = __of_get_property(np, "device_type", NULL) ? : "<NULL>";
-
-	phandle = __of_get_property(np, "phandle", &sz);
-	if (!phandle)
-		phandle = __of_get_property(np, "linux,phandle", &sz);
-	if (IS_ENABLED(CONFIG_PPC_PSERIES) && !phandle)
-		phandle = __of_get_property(np, "ibm,phandle", &sz);
-	np->phandle = (phandle && (sz >= 4)) ? be32_to_cpup(phandle) : 0;
+	if (!of_node_check_flag(np, OF_OVERLAY)) {
+		np->name = __of_get_property(np, "name", NULL);
+		np->type = __of_get_property(np, "device_type", NULL);
+		if (!np->name)
+			np->name = "<NULL>";
+		if (!np->type)
+			np->type = "<NULL>";
+
+		phandle = __of_get_property(np, "phandle", &sz);
+		if (!phandle)
+			phandle = __of_get_property(np, "linux,phandle", &sz);
+		if (IS_ENABLED(CONFIG_PPC_PSERIES) && !phandle)
+			phandle = __of_get_property(np, "ibm,phandle", &sz);
+		if (phandle && (sz >= 4))
+			np->phandle = be32_to_cpup(phandle);
+		else
+			np->phandle = 0;
+	}
  
  	np->child = NULL;
  	np->sibling = np->parent->child;
diff --git a/drivers/of/overlay.c b/drivers/of/overlay.c
index 9808aae..b2704ba 100644
--- a/drivers/of/overlay.c
+++ b/drivers/of/overlay.c
@@ -301,10 +301,11 @@ static int add_changeset_property(struct overlay_changeset *ovcs,
  	struct property *new_prop = NULL, *prop;
  	int ret = 0;
  
-	if (!of_prop_cmp(overlay_prop->name, "name") ||
-	    !of_prop_cmp(overlay_prop->name, "phandle") ||
-	    !of_prop_cmp(overlay_prop->name, "linux,phandle"))
-		return 0;
+	if (target->in_livetree)
+		if (!of_prop_cmp(overlay_prop->name, "name") ||
+		    !of_prop_cmp(overlay_prop->name, "phandle") ||
+		    !of_prop_cmp(overlay_prop->name, "linux,phandle"))
+			return 0;
  
  	if (target->in_livetree)
  		prop = of_find_property(target->np, overlay_prop->name, NULL);
@@ -322,12 +323,17 @@ static int add_changeset_property(struct overlay_changeset *ovcs,
  	if (!new_prop)
  		return -ENOMEM;
  
-	if (!prop)
+	if (!prop) {
+		if (!target->in_livetree) {
+			new_prop->next = target->np->deadprops;
+			target->np->deadprops = new_prop;
+		}
  		ret = of_changeset_add_property(&ovcs->cset, target->np,
  						new_prop);
-	else
+	} else {
  		ret = of_changeset_update_property(&ovcs->cset, target->np,
  						   new_prop);
+	}
  
  	if (ret) {
  		kfree(new_prop->name);
@@ -382,9 +388,10 @@ static int add_changeset_node(struct overlay_changeset *ovcs,
  		struct target *target, struct device_node *node)
  {
  	const char *node_kbasename;
+	const __be32 *phandle;
  	struct device_node *tchild;
  	struct target target_child;
-	int ret = 0;
+	int ret = 0, size;
  
  	node_kbasename = kbasename(node->full_name);
  
@@ -398,6 +405,19 @@ static int add_changeset_node(struct overlay_changeset *ovcs,
  			return -ENOMEM;
  
  		tchild->parent = target->np;
+		tchild->name = __of_get_property(node, "name", NULL);
+		tchild->type = __of_get_property(node, "device_type", NULL);
+
+		if (!tchild->name)
+			tchild->name = "<NULL>";
+		if (!tchild->type)
+			tchild->type = "<NULL>";
+
+		/* ignore obsolete "linux,phandle" */
+		phandle = __of_get_property(node, "phandle", &size);
+		if (phandle && (size == 4))
+			tchild->phandle = be32_to_cpup(phandle);
+
  		of_node_set_flag(tchild, OF_OVERLAY);
  
  		ret = of_changeset_attach_node(&ovcs->cset, tchild);
-- 
2.7.4

