Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D71C31C1FD5
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 23:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgEAVna (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 17:43:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbgEAVn3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 May 2020 17:43:29 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EF50C061A0C;
        Fri,  1 May 2020 14:43:28 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id x17so13177636wrt.5;
        Fri, 01 May 2020 14:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k4iB7kYfbLttb4YHb0hIHMQWZXXWpmHPyDeGkvvrkzM=;
        b=TytGx4cAkJjG73EC35zKdiVqF27g4gkE+3TiIG9bZ+FWJcM5MinF9rNbwFdzLRxidM
         8s+2s7cMdLMMhJ8Trq/4pt9hmAyvJ8upVNUrbW3pxgyz2KTevSJlYNAutE7FH6UBgTkL
         OPXczHdSl4Qa1PNYcVprjOR/fNhXA2qwbAG+Dkoa5L1Fkw6Z4nUmy/1hOJYtrOORwGHw
         0P172brNBNoPMxeeE4GC6J0wcBcjqgcRbCDrWZPVu+1SgSIM8W8LUcXOpg9V+J4xjmvW
         CrHS8T1bsu6X8ide9rGAYSA9n0Sb/b/3w9Au+Mzz45OPg1e3iIy/amver15p9eHy9+0T
         3Ckw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k4iB7kYfbLttb4YHb0hIHMQWZXXWpmHPyDeGkvvrkzM=;
        b=S0xWBgv5F9bGMMwoiC4hWJmbKs+JuqJxgLBOcv7wn5u5nJJJjIfxyur0TFlV3ZDffj
         d68VxZlyYhkSE6bZus2lYGb75z4KpocZrT9WAVcbfaI5tG+uUUwwIHbgIvtu/By63OA9
         R4wPdkjMyZV93/ta9BDGfo6N8Lvv4baTYym6YDOwb6zIaD7bIYCfXQnjRhYK/Iv1nxg5
         7U7ilWZzxFRsqQyiCSKtZqxCwqTT3CYA/blf5E3ZL/gIN/f9wVFn2Zx8Iu/C71GN4ZKw
         uLSTdfVCzstdhdL9QCObe0YKbH7w1olDYGw+k1XViLno2XE9a77/dz51aYsYoK/6jUt0
         5Mfg==
X-Gm-Message-State: AGi0PuZvbBQYbc9FFABbowlokZxLAgzJfD4CemfMElHuNuN3fkxvmWU8
        Aq/SU4+v/dwB+9jROfU/flhqxyUI
X-Google-Smtp-Source: APiQypJhSV5JPJvKRKcUl3mh/ccEhO9BXPSpSJsU3Nf8AceXp3ESVmIpIsmxEhGOZZ8Fzl1tM7jR5w==
X-Received: by 2002:a5d:664f:: with SMTP id f15mr5889140wrw.72.1588369406984;
        Fri, 01 May 2020 14:43:26 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t2sm1207734wmt.15.2020.05.01.14.43.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 May 2020 14:43:26 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>, stable@vger.kernel.org,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 4/9] lpfc: Fix negation of else clause in lpfc_prep_node_fc4type
Date:   Fri,  1 May 2020 14:43:05 -0700
Message-Id: <20200501214310.91713-5-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200501214310.91713-1-jsmart2021@gmail.com>
References: <20200501214310.91713-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Implementation of a previous patch added a condition to an if check
that always end up with the if test being true. Execution of the else
clause was inadvertantly negated.  The additional condition check was
incorrect and unnecessary after the other modifications had been done
in that patch.

Remove the check from the if series.

Fixes: b95b21193c85 ("scsi: lpfc: Fix loss of remote port after devloss due to lack of RPIs")
Cc: <stable@vger.kernel.org> # v5.4+
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_ct.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 2aa578d20f8c..7fce73c39c1c 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -462,7 +462,6 @@ lpfc_prep_node_fc4type(struct lpfc_vport *vport, uint32_t Did, uint8_t fc4_type)
 	struct lpfc_nodelist *ndlp;
 
 	if ((vport->port_type != LPFC_NPIV_PORT) ||
-	    (fc4_type == FC_TYPE_FCP) ||
 	    !(vport->ct_flags & FC_CT_RFF_ID) || !vport->cfg_restrict_login) {
 
 		ndlp = lpfc_setup_disc_node(vport, Did);
-- 
2.26.1

