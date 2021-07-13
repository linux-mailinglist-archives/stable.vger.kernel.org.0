Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48F953C77E2
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 22:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235571AbhGMUYj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 16:24:39 -0400
Received: from mx-lax3-2.ucr.edu ([169.235.156.37]:39229 "EHLO
        mx-lax3-2.ucr.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235322AbhGMUYi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Jul 2021 16:24:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=ucr.edu; i=@ucr.edu; q=dns/txt; s=selector3;
  t=1626207708; x=1657743708;
  h=from:subject:to:cc:message-id:date:mime-version;
  bh=WzlJ7A345q6jOqsIN3o7gRqpRPe8snJXGvo3AhrFKEE=;
  b=ZKBYC29o6n5JRbXBro1AsnhwF5OFTNkLSh3ZezFrLElVcmiUngYGxNBF
   dPTu34GPoSezUWk/v4hO9ClXY1zGIo21qwMXBhXxZs0EV7Pba9ujI7uP1
   IM8NP0r5UEngdAiq+BVqFy9+ceWCWnkJ9KbVsKwkP9hddoKepKgRd0bee
   pmVST09foKPM9ykMEmAATaDcndgRI4WmYPpRvFtqN8vziPgytP/cFUQGd
   rIfzaD4VOjHkqZNTVFG3Vn+MVJxLYs22uhkkXToqGrk8/2jxavfFofLwN
   bUPyIexri2JOh8fL9kO4wNU/t5ubQVPdU8EhhvfsUE1KJnx4+jWfJk/Zp
   g==;
IronPort-SDR: i3TnphvR73EA0JOOzlxxeCqoZXRly4yo2Ki9MKlLQvTQolFIBG2Yk679k4fIrDHarlyTeiY7Qy
 tTOzJ93CG4oBRS0j5PJ05ClXl8SOj+fuu52V2xqAaRpt6dHnhiTzGPGw2B+R1dAG+PA0DYOy7Q
 0xbuIn96xENZas3bCZjca+pEBUctYVmjLzLygvtDH0GjMY2eHXI3sTSgOrp79u5cNbzuFTnTLg
 D3QhVn0sPYs2YppGMIU8S58yePMa0Gcm80TSWQdQSH1nSmOwP6/uDfKJR5aOyeQFwChil6AdgE
 wzY=
X-IPAS-Result: =?us-ascii?q?A2ErBQDe9O1gf0bYVdFaHgEBCxIMgg4LgVOCJmuESJEwL?=
 =?us-ascii?q?YQZkgWHOwIJAQEBDQEBPwIEAQGEVAKCeAIlNwYOAgQBAQEBAwIDAQEBAQUBA?=
 =?us-ascii?q?QYBAQEBAQEFBAEBAhABAW6FL0aCOCKDdAECARURBFIsAwECKwIEMgEFARQbB?=
 =?us-ascii?q?gIBAR6CTwGDBwGbPIEEPYo4en8zgQGEZ4NSAQkNgVMQCQEIgSiOEoIpgRUnD?=
 =?us-ascii?q?IEIgiiEWwmCd4JkBIMWAYENFIJSQFMBAQGQVI1aDVCadoIPAQYCgwochTiDB?=
 =?us-ascii?q?ZVjBhQmg2ORWEKQXC2tBogmhTACCgcGECOBToF/MxolgWyBS1AZDohshT8Wj?=
 =?us-ascii?q?kwhMjgCBgoBAQMJfIZ9AQE?=
IronPort-PHdr: A9a23:gRwyXxS+3dI70fIAEe/GCMGzUtpsom2fAWYlg6HPa5pwe6iut67vI
 FbYra00ygOTBcOCtrkU0qKW6/mmBTVRp87Z8TgrS99lb1c9k8IYnggtUoauKHbQC7rUVRE8B
 9lIT1R//nu2YgB/Ecf6YEDO8DXptWZBUhrwOhBoKevrB4Xck9q41/yo+53Ufg5EmCexbal9I
 RmosQndrNQajIttJqsy1xfCv39Ed/hLyW9yKl+fghLx6t2s8JJ/9ihbpu4s+dNHXajmZaozU
 KZWDC4hM2A75c3rsQfMQA6S7XYCUWsYjwRFDRHd4B71Qpn+vC36tvFg2CaBJs35Uao0WTW54
 Kh1ThLjlToKOCQ48GHTjcxwkb5brRe8rBFx34LYfIeYP+d4c6jAf90VWHBBU95RWSJcHI2yb
 IUBAOQOMulEtIT9okcCoAGkCAWwCu7iyDlFjWL2060g1OQhFBnL0w0hH90Ut3TbsNX1O7kUU
 euoz6bIyijDZO5R1Dby6YnIdQ0hre2RUb9yasfR1FUgFxnfglqOtIPlIiqY2+IQuGeU8+RuT
 /igi3I7qw5vuDivwN8hh4bGi48W1lzJ6St0zoY3KNC8TEN2f9ypHptQuiyEOIV7X98vTmF1t
 Ss417AIt4C2cDYUxZk62xLTduGKfoiH7x/lSe2fLzB4hHd/d7K+gRa/6VSgyvfhVsaqylpKq
 DRKksXKu3sQ1BLT8tCKRuVh8kqlwzqC1ADe5vtaLUwplKfXMZwszqIompYNsEnPAjP6lUD3g
 aCKdkgo5+2l5ub9bbjkuJCRMpJ7hh3wP6ksn8GyD/g3PwsAUmWe5Oix1rzu8VD8TbhIkvE5j
 rXWvZXHKcsFpaO2GAlY2Zs55RmlFTepytEYkGECLFJCZR2IkZDkO0rLIPDkFfe/hEmskCtzy
 /DGILLhBpLNI2DGkLj7fLZ971dQyBIxzdxC/p5UBLMMLO7pVk/+s9zYCRA5MwiqzOr9FNp90
 YYeVXqOAq+fLqzSrUeF6vwzL+SIfoMYuzbwJ+I76/LzjHI1g10QcbWx0ZsScn+4H/BmI0uDY
 Xrrh9cMCWgLvws5TOz3lFGOTDxeam2vX60g/DE3EpypApreRoy1mryOwD+7HoFKZmBBEl2MC
 mvoeJ+fVPcIdi2fOdFhkjMaWri7UYMh1g+htBX8y7V5KurY4CoYtYjs1Is92+qGmgs/+hR3F
 cOU0yeGSGQnsHkPQmoG3al4qkxwzB+x1rUw1+xKEsELvqxhTwwgc5PQ0ropWJjJRgvdc4LRG
 x6dSdK8DGRpJu8=
IronPort-HdrOrdr: A9a23:HKa+6qgrwE5xe9K25uxlP7PcbXBQXukji2hC6mlwRA09TyVXrb
 HLoB1p726PtN9xYgBapTnuAtjnfZqxz+8X3WBzB8bbYOCFghrOEGgK1+KLqF3d8kXFl9K1vp
 0QEZSWZueAaGSSwfyKmTVQ0OxM/DBEysqVbCvloEuFhDsHBZ1d0w==
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="5.84,237,1620716400"; 
   d="scan'208";a="53936397"
Received: from mail-pj1-f70.google.com ([209.85.216.70])
  by smtp-lax3-2.ucr.edu with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Jul 2021 13:21:47 -0700
Received: by mail-pj1-f70.google.com with SMTP id 16-20020a17090a19d0b029016fc64ff1a2so11056841pjj.1
        for <stable@vger.kernel.org>; Tue, 13 Jul 2021 13:21:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language;
        bh=fmIqQ9Udybx7MUcIYh78Frxz8dxd7XVLif52k+yQNpI=;
        b=ZD1TWFfx+/HraNggkEKd41YI3CylUHqeQAqxiGjoB2YdS1huJeaQrnayYtRm4cH4ha
         nHgt8WJbBnMjNi+gTHG3RpCChNfINoDNJIb5Qi19b/L8Vqx+rnEZhXIgCBnwOzE8x/aM
         LNdBm6HAlkkEUzmnTa3/2H3MgoBv8BVDaB5axAy4dxFBjzcEK+WGHDeFC4SXXh/YiTgb
         +Xd4lv05UifLUNSMo+nfGBRiIClMla0GIydElK3+yjQC2ocxjVqFZ41PyMAcq0I5DX06
         jFDOFQO3AGs7+uVHEQw6ft1ooQUnVQ7Wm14sFnjf8bSTbHq1CCqNUULA0of3w7nQE6Ek
         cm2A==
X-Gm-Message-State: AOAM530TvJdCyTSNrlrAwJ5XbApXRoi6TJmFNUxojGsvlKGUUdH7MBF3
        27WBWR7KwhqcJdSIlJvl2XJYR4af32hagQQrqBQODocO9ChWEUCkxNPyo534DJklWVnz36ts5+l
        YRzbwiLeCRX1ge9u/hg==
X-Received: by 2002:a17:902:b203:b029:127:16e0:286a with SMTP id t3-20020a170902b203b029012716e0286amr4927455plr.0.1626207706952;
        Tue, 13 Jul 2021 13:21:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwcvyTGQYVGPKVhWVZ/ghKGrI2DXRLJyl0cZhoFvNid6Pq+GmY5oD8zqIiBMbuCb8Y91DNMIA==
X-Received: by 2002:a17:902:b203:b029:127:16e0:286a with SMTP id t3-20020a170902b203b029012716e0286amr4927432plr.0.1626207706629;
        Tue, 13 Jul 2021 13:21:46 -0700 (PDT)
Received: from ?IPv6:2600:6c51:7a7e:d037:3c83:1761:70cc:1e8b? ([2600:6c51:7a7e:d037:3c83:1761:70cc:1e8b])
        by smtp.gmail.com with ESMTPSA id u16sm15204pfh.205.2021.07.13.13.21.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jul 2021 13:21:46 -0700 (PDT)
From:   Xiaochen Zou <xzou017@ucr.edu>
Subject: [PATCH 0/1] can: fix a potential UAF access in
 j1939_session_deactivate()
To:     greg@kroah.com
Cc:     stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-can@vger.kernel.org
Message-ID: <aa64ef28-35d8-9deb-2756-8080296b7e3e@ucr.edu>
Date:   Tue, 13 Jul 2021 13:21:44 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------9FC6497483A83D5ACDE3F243"
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------9FC6497483A83D5ACDE3F243
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit


Xiaochen Zou (1):
  can: fix a potential UAF access in j1939_session_deactivate(). Both
    session and session->priv may be freed in
    j1939_session_deactivate_locked(). It leads to potential UAF read
    and write in j1939_session_list_unlock(). The free chain is

j1939_session_deactivate_locked()->j1939_session_put()->__j1939_session_release()->j1939_session_destroy().
    To fix this bug, I moved j1939_session_put() behind
    j1939_session_deactivate_locked(), and guarded it with a check of
    active since the session would be freed only if active is true.

 net/can/j1939/transport.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

-- 
2.17.1

From 9c4733d093e05db22eb89825579c83e020c3c1a6 Mon Sep 17 00:00:00 2001
From: Xiaochen Zou <xzou017@ucr.edu>
Date: Tue, 13 Jul 2021 13:15:59 -0700
Subject: [PATCH 1/1] can: fix a potential UAF access in
 j1939_session_deactivate().
To: greg@kroah.com
Cc: stable@vger.kernel.org,netdev@vger.kernel.org,linux-can@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="------------2.17.1"

This is a multi-part message in MIME format.

--------------9FC6497483A83D5ACDE3F243
Content-Type: text/plain; charset=UTF-8;
 name="Attached Message Part"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="Attached Message Part"

Qm90aCBzZXNzaW9uIGFuZCBzZXNzaW9uLT5wcml2IG1heSBiZSBmcmVlZCBpbg0KajE5Mzlf
c2Vzc2lvbl9kZWFjdGl2YXRlX2xvY2tlZCgpLiBJdCBsZWFkcyB0byBwb3RlbnRpYWwgVUFG
IHJlYWQgYW5kIHdyaXRlDQppbiBqMTkzOV9zZXNzaW9uX2xpc3RfdW5sb2NrKCkuIFRoZSBm
cmVlIGNoYWluIGlzDQpqMTkzOV9zZXNzaW9uX2RlYWN0aXZhdGVfbG9ja2VkKCktPmoxOTM5
X3Nlc3Npb25fcHV0KCktPl9fajE5Mzlfc2Vzc2lvbl9yZWxlYXNlKCktPmoxOTM5X3Nlc3Np
b25fZGVzdHJveSgpLg0KVG8gZml4IHRoaXMgYnVnLCBJIG1vdmVkIGoxOTM5X3Nlc3Npb25f
cHV0KCkgYmVoaW5kDQpqMTkzOV9zZXNzaW9uX2RlYWN0aXZhdGVfbG9ja2VkKCksIGFuZCBn
dWFyZGVkIGl0IHdpdGggYSBjaGVjayBvZiBhY3RpdmUNCnNpbmNlIHRoZSBzZXNzaW9uIHdv
dWxkIGJlIGZyZWVkIG9ubHkgaWYgYWN0aXZlIGlzIHRydWUuDQogDQpTaWduZWQtb2ZmLWJ5
OiBYaWFvY2hlbiBab3UgPHh6b3UwMTdAdWNyLmVkdT4NCi0tLQ0KIG5ldC9jYW4vajE5Mzkv
dHJhbnNwb3J0LmMgfCA4ICsrKysrKy0tDQogMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9u
cygrKSwgMiBkZWxldGlvbnMoLSkNCg0KDQo=
--------------9FC6497483A83D5ACDE3F243
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-can-fix-a-potential-UAF-access-in-j1939_session_deac.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-can-fix-a-potential-UAF-access-in-j1939_session_deac.pa";
 filename*1="tch"

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index c3946c355882..c64bd5e8118a 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1067,7 +1067,6 @@ static bool j1939_session_deactivate_locked(struct j1939_session *session)
 
 		list_del_init(&session->active_session_list_entry);
 		session->state = J1939_SESSION_DONE;
-		j1939_session_put(session);
 	}
 
 	return active;
@@ -1080,6 +1079,8 @@ static bool j1939_session_deactivate(struct j1939_session *session)
 	j1939_session_list_lock(session->priv);
 	active = j1939_session_deactivate_locked(session);
 	j1939_session_list_unlock(session->priv);
+	if (active)
+		j1939_session_put(session);
 
 	return active;
 }
@@ -2127,6 +2128,7 @@ void j1939_simple_recv(struct j1939_priv *priv, struct sk_buff *skb)
 int j1939_cancel_active_session(struct j1939_priv *priv, struct sock *sk)
 {
 	struct j1939_session *session, *saved;
+	bool active;
 
 	netdev_dbg(priv->ndev, "%s, sk: %p\n", __func__, sk);
 	j1939_session_list_lock(priv);
@@ -2140,7 +2142,9 @@ int j1939_cancel_active_session(struct j1939_priv *priv, struct sock *sk)
 				j1939_session_put(session);
 
 			session->err = ESHUTDOWN;
-			j1939_session_deactivate_locked(session);
+			active = j1939_session_deactivate_locked(session);
+			if (active)
+				j1939_session_put(session);
 		}
 	}
 	j1939_session_list_unlock(priv);


--------------9FC6497483A83D5ACDE3F243--
