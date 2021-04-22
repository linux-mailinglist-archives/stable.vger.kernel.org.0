Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 344AE3679CC
	for <lists+stable@lfdr.de>; Thu, 22 Apr 2021 08:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbhDVGUp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Apr 2021 02:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbhDVGUn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Apr 2021 02:20:43 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACB31C06174A
        for <stable@vger.kernel.org>; Wed, 21 Apr 2021 23:20:04 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id s7so43451222wru.6
        for <stable@vger.kernel.org>; Wed, 21 Apr 2021 23:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AYUQbXF7EkhEVrD/RBAExZZsqLQQMMLy8WPqj+KPaFM=;
        b=gmftAI/fLNwy8FI2MxZJf6ylFvrFfszmep/IvT1T6QhRtkeg77purrqYajjCn7hFTm
         3zw0K/RzmbtmBV2M1Wqbsot54B+cza0YHXJWID58rkPt4L1L6qykiJmyYS85cozhZxfX
         N0BgYKX0Joho/Smr229tfpl6dTgCjWn9qjAnxYiSWsUD+s/JxOL6M/ih29hEwImCvqbi
         UP7TergNVH984vJl9Ip5b+qHKpD1+D7R4HO5KXZ7PS4iXqJwUscheMBaszsRpAlfdITM
         zzkf5abSnwxAqgF9OV0/SJYt+/VHcwVDNqAsPE3hC9QPmDr+HpYbXZIJPbIumYPT5cXl
         fa+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AYUQbXF7EkhEVrD/RBAExZZsqLQQMMLy8WPqj+KPaFM=;
        b=mR82JdYSnLM121VA1RiGkZRlmZtxTiJOzvq8JGvqFqoIU6KSSYTq31DPdZgMHo3wWY
         ZSbJfCv+4tx00nRlDWKCaf/jv1ywaUXkFzCGgSVmR5Qd56HpNUZfZGuTQK/FZXVn+M/f
         mGhVaRRrFn4VMOe8CO7DpU+L2CIwWAbEHPSddD3Wtx1XFhm53ee/dH1Eo9cZewlbCu7b
         5wMmtUjNtropB3PzB7H0sFt1pXR4FhdFuEMXeeM/XnUAxyeijRvGrVaHn8ggyi0ECt83
         f3Lnpw/OcfmP7Xk0mNn9l2bLqi7uHZvrO/W564LwrXJRlHLdkiIC6WcjQNirfflLXnqH
         JrLA==
X-Gm-Message-State: AOAM533ZLwy9Yc86NZuV+pFWw/+zb+xH+CWD5QUGYPfEHmDr7dAItQBO
        gtvbN/fHPR6P7MHS3njywLg=
X-Google-Smtp-Source: ABdhPJzjOfamePcbFGko/u3enwwRRpFzPbeJziMu8JrjtgdVTWbB/nNnt72XNAuQEyWWPLlYNes3Cg==
X-Received: by 2002:a5d:6d48:: with SMTP id k8mr1954719wri.93.1619072403205;
        Wed, 21 Apr 2021 23:20:03 -0700 (PDT)
Received: from debian (host-84-13-30-150.opaltelecom.net. [84.13.30.150])
        by smtp.gmail.com with ESMTPSA id s21sm1716835wmc.10.2021.04.21.23.20.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 23:20:01 -0700 (PDT)
Date:   Thu, 22 Apr 2021 07:19:59 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Subject: [resend] revert series of umn.edu commits for v5.4.y
Message-ID: <YIEVj3XVaOVG6MOu@debian>
References: <YICidTdSYPut4oVa@debian>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="dKgri1t8WkgmJnuf"
Content-Disposition: inline
In-Reply-To: <YICidTdSYPut4oVa@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--dKgri1t8WkgmJnuf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

Resending with individual attachments as the previous mail with all the
attachments (sent last night) did not appear in https://lore.kernel.org/stable.

This is based on the 190 commits that you posted for mainline. Out of
that 24 patches had a reply mail asking not to revert (till last night).
So, the attached series for stable is based on the remaining 166 commits.
I have borrowed the commit message from your series.


--
Regards
Sudip

--dKgri1t8WkgmJnuf
Content-Type: application/mbox
Content-Disposition: attachment; filename="revertseries_v5.4.mbox"
Content-Transfer-Encoding: quoted-printable

=46rom 518c465258045325a1d87c6ad00c5474c126d4fd Mon Sep 17 00:00:00 2001=0A=
=46rom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 20=
21 20:23:37 +0100=0ASubject: [PATCH 001/151] Revert "rapidio: fix a NULL po=
inter dereference when=0A create_workqueue() fails"=0A=0AThis reverts commi=
t 23015b22e47c5409620b1726a677d69e5cd032ba.=0A=0ACommits from @umn.edu addr=
esses have been found to be submitted in "bad=0Afaith" to try to test the k=
ernel community's ability to review "known=0Amalicious" changes.  The resul=
t of these submissions can be found in a=0Apaper published at the 42nd IEEE=
 Symposium on Security and Privacy=0Aentitled, "Open Source Insecurity: Ste=
althily Introducing=0AVulnerabilities via Hypocrite Commits" written by Qiu=
shi Wu (University=0Aof Minnesota) and Kangjie Lu (University of Minnesota)=
=2E=0A=0ABecause of this, all submissions from this group must be reverted =
=66rom=0Athe kernel tree and will need to be re-reviewed again to determine=
 if=0Athey actually are a valid fix.  Until that work is complete, remove t=
his=0Achange to ensure that no problems are being introduced into the=0Acod=
ebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A-=
--=0A drivers/rapidio/rio_cm.c | 8 --------=0A 1 file changed, 8 deletions(=
-)=0A=0Adiff --git a/drivers/rapidio/rio_cm.c b/drivers/rapidio/rio_cm.c=0A=
index 50ec53d67a4c..e6c16f04f2b4 100644=0A--- a/drivers/rapidio/rio_cm.c=0A=
+++ b/drivers/rapidio/rio_cm.c=0A@@ -2138,14 +2138,6 @@ static int riocm_ad=
d_mport(struct device *dev,=0A 	mutex_init(&cm->rx_lock);=0A 	riocm_rx_fill=
(cm, RIOCM_RX_RING_SIZE);=0A 	cm->rx_wq =3D create_workqueue(DRV_NAME "/rxq=
");=0A-	if (!cm->rx_wq) {=0A-		riocm_error("failed to allocate IBMBOX_%d on=
 %s",=0A-			    cmbox, mport->name);=0A-		rio_release_outb_mbox(mport, cmbo=
x);=0A-		kfree(cm);=0A-		return -ENOMEM;=0A-	}=0A-=0A 	INIT_WORK(&cm->rx_wo=
rk, rio_ibmsg_handler);=0A =0A 	cm->tx_slot =3D 0;=0A-- =0A2.30.2=0A=0A=0AF=
rom 165addab25c895d09d2e01999b2727c7fdc061e9 Mon Sep 17 00:00:00 2001=0AFro=
m: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20=
:23:38 +0100=0ASubject: [PATCH 002/151] Revert "ASoC: cs43130: fix a NULL p=
ointer=0A dereference"=0A=0AThis reverts commit a2be42f18d409213bb7e7a736e3=
ef6ba005115bb.=0A=0ACommits from @umn.edu addresses have been found to be s=
ubmitted in "bad=0Afaith" to try to test the kernel community's ability to =
review "known=0Amalicious" changes.  The result of these submissions can be=
 found in a=0Apaper published at the 42nd IEEE Symposium on Security and Pr=
ivacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVulnera=
bilities via Hypocrite Commits" written by Qiushi Wu (University=0Aof Minne=
sota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, all s=
ubmissions from this group must be reverted from=0Athe kernel tree and will=
 need to be re-reviewed again to determine if=0Athey actually are a valid f=
ix.  Until that work is complete, remove this=0Achange to ensure that no pr=
oblems are being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip =
Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A sound/soc/codecs/cs43130.c =
| 2 --=0A 1 file changed, 2 deletions(-)=0A=0Adiff --git a/sound/soc/codecs=
/cs43130.c b/sound/soc/codecs/cs43130.c=0Aindex 7fb34422a2a4..bb46e993c353 =
100644=0A--- a/sound/soc/codecs/cs43130.c=0A+++ b/sound/soc/codecs/cs43130.=
c=0A@@ -2319,8 +2319,6 @@ static int cs43130_probe(struct snd_soc_component=
 *component)=0A 			return ret;=0A =0A 		cs43130->wq =3D create_singlethread=
_workqueue("cs43130_hp");=0A-		if (!cs43130->wq)=0A-			return -ENOMEM;=0A 	=
	INIT_WORK(&cs43130->work, cs43130_imp_meas);=0A 	}=0A =0A-- =0A2.30.2=0A=
=0A=0AFrom c30b1e8c020691402c538bf97f876d5f90011ff1 Mon Sep 17 00:00:00 200=
1=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr =
2021 20:23:38 +0100=0ASubject: [PATCH 003/151] Revert "ASoC: rt5645: fix a =
NULL pointer dereference"=0A=0AThis reverts commit 51dd97d1df5fb9ac58b9b358=
e63e67b530f6ae21.=0A=0ACommits from @umn.edu addresses have been found to b=
e submitted in "bad=0Afaith" to try to test the kernel community's ability =
to review "known=0Amalicious" changes.  The result of these submissions can=
 be found in a=0Apaper published at the 42nd IEEE Symposium on Security and=
 Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVuln=
erabilities via Hypocrite Commits" written by Qiushi Wu (University=0Aof Mi=
nnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, al=
l submissions from this group must be reverted from=0Athe kernel tree and w=
ill need to be re-reviewed again to determine if=0Athey actually are a vali=
d fix.  Until that work is complete, remove this=0Achange to ensure that no=
 problems are being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sud=
ip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A sound/soc/codecs/rt5645.=
c | 3 ---=0A 1 file changed, 3 deletions(-)=0A=0Adiff --git a/sound/soc/cod=
ecs/rt5645.c b/sound/soc/codecs/rt5645.c=0Aindex c83f7f5da96b..44e88d0dbb7a=
 100644=0A--- a/sound/soc/codecs/rt5645.c=0A+++ b/sound/soc/codecs/rt5645.c=
=0A@@ -3419,9 +3419,6 @@ static int rt5645_probe(struct snd_soc_component *=
component)=0A 		RT5645_HWEQ_NUM, sizeof(struct rt5645_eq_param_s),=0A 		GFP=
_KERNEL);=0A =0A-	if (!rt5645->eq_param)=0A-		return -ENOMEM;=0A-=0A 	retur=
n 0;=0A }=0A =0A-- =0A2.30.2=0A=0A=0AFrom 881b0013eea44306c12cec8ac8d995acb=
3f2d1af Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@=
gmail.com>=0ADate: Wed, 21 Apr 2021 20:23:38 +0100=0ASubject: [PATCH 004/15=
1] Revert "ALSA: usx2y: fix a double free bug"=0A=0AThis reverts commit cbb=
88db76a1536e02e93e5bd37ebbfbb6c4043a9.=0A=0ACommits from @umn.edu addresses=
 have been found to be submitted in "bad=0Afaith" to try to test the kernel=
 community's ability to review "known=0Amalicious" changes.  The result of =
these submissions can be found in a=0Apaper published at the 42nd IEEE Symp=
osium on Security and Privacy=0Aentitled, "Open Source Insecurity: Stealthi=
ly Introducing=0AVulnerabilities via Hypocrite Commits" written by Qiushi W=
u (University=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=
=0ABecause of this, all submissions from this group must be reverted from=
=0Athe kernel tree and will need to be re-reviewed again to determine if=0A=
they actually are a valid fix.  Until that work is complete, remove this=0A=
change to ensure that no problems are being introduced into the=0Acodebase.=
=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A =
sound/usb/usx2y/usbusx2y.c | 4 +++-=0A 1 file changed, 3 insertions(+), 1 d=
eletion(-)=0A=0Adiff --git a/sound/usb/usx2y/usbusx2y.c b/sound/usb/usx2y/u=
sbusx2y.c=0Aindex c54158146917..01b4de83bee8 100644=0A--- a/sound/usb/usx2y=
/usbusx2y.c=0A+++ b/sound/usb/usx2y/usbusx2y.c=0A@@ -280,8 +280,10 @@ int u=
sX2Y_In04_init(struct usX2Ydev *usX2Y)=0A 	if (! (usX2Y->In04urb =3D usb_al=
loc_urb(0, GFP_KERNEL)))=0A 		return -ENOMEM;=0A =0A-	if (! (usX2Y->In04Buf=
 =3D kmalloc(21, GFP_KERNEL)))=0A+	if (! (usX2Y->In04Buf =3D kmalloc(21, GF=
P_KERNEL))) {=0A+		usb_free_urb(usX2Y->In04urb);=0A 		return -ENOMEM;=0A+	}=
=0A 	 =0A 	init_waitqueue_head(&usX2Y->In04WaitQueue);=0A 	usb_fill_int_urb=
(usX2Y->In04urb, usX2Y->dev, usb_rcvintpipe(usX2Y->dev, 0x4),=0A-- =0A2.30.=
2=0A=0A=0AFrom 85b22b9f78dd1c7bbc1f3c48a3d03047b81839ea Mon Sep 17 00:00:00=
 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 =
Apr 2021 20:23:39 +0100=0ASubject: [PATCH 005/151] Revert "tracing: Fix a m=
emory leak by early error=0A exit in trace_pid_write()"=0A=0AThis reverts c=
ommit 91862cc7867bba4ee5c8fcf0ca2f1d30427b6129.=0A=0ACommits from @umn.edu =
addresses have been found to be submitted in "bad=0Afaith" to try to test t=
he kernel community's ability to review "known=0Amalicious" changes.  The r=
esult of these submissions can be found in a=0Apaper published at the 42nd =
IEEE Symposium on Security and Privacy=0Aentitled, "Open Source Insecurity:=
 Stealthily Introducing=0AVulnerabilities via Hypocrite Commits" written by=
 Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (University of Minnes=
ota).=0A=0ABecause of this, all submissions from this group must be reverte=
d from=0Athe kernel tree and will need to be re-reviewed again to determine=
 if=0Athey actually are a valid fix.  Until that work is complete, remove t=
his=0Achange to ensure that no problems are being introduced into the=0Acod=
ebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A-=
--=0A kernel/trace/trace.c | 5 +----=0A 1 file changed, 1 insertion(+), 4 d=
eletions(-)=0A=0Adiff --git a/kernel/trace/trace.c b/kernel/trace/trace.c=
=0Aindex 1b5f54b309be..15788f231e33 100644=0A--- a/kernel/trace/trace.c=0A+=
++ b/kernel/trace/trace.c=0A@@ -517,10 +517,8 @@ int trace_pid_write(struct=
 trace_pid_list *filtered_pids,=0A 	 * not modified.=0A 	 */=0A 	pid_list =
=3D kmalloc(sizeof(*pid_list), GFP_KERNEL);=0A-	if (!pid_list) {=0A-		trace=
_parser_put(&parser);=0A+	if (!pid_list)=0A 		return -ENOMEM;=0A-	}=0A =0A =
	pid_list->pid_max =3D READ_ONCE(pid_max);=0A =0A@@ -530,7 +528,6 @@ int tr=
ace_pid_write(struct trace_pid_list *filtered_pids,=0A =0A 	pid_list->pids =
=3D vzalloc((pid_list->pid_max + 7) >> 3);=0A 	if (!pid_list->pids) {=0A-		=
trace_parser_put(&parser);=0A 		kfree(pid_list);=0A 		return -ENOMEM;=0A 	}=
=0A-- =0A2.30.2=0A=0A=0AFrom 19a8d07b249b28f24709cfb74a57a7a539479e72 Mon S=
ep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A=
Date: Wed, 21 Apr 2021 20:23:39 +0100=0ASubject: [PATCH 006/151] Revert "rs=
i: Fix NULL pointer dereference in kmalloc"=0A=0AThis reverts commit d5414c=
2355b20ea8201156d2e874265f1cb0d775.=0A=0ACommits from @umn.edu addresses ha=
ve been found to be submitted in "bad=0Afaith" to try to test the kernel co=
mmunity's ability to review "known=0Amalicious" changes.  The result of the=
se submissions can be found in a=0Apaper published at the 42nd IEEE Symposi=
um on Security and Privacy=0Aentitled, "Open Source Insecurity: Stealthily =
Introducing=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu (=
University=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=0AB=
ecause of this, all submissions from this group must be reverted from=0Athe=
 kernel tree and will need to be re-reviewed again to determine if=0Athey a=
ctually are a valid fix.  Until that work is complete, remove this=0Achange=
 to ensure that no problems are being introduced into the=0Acodebase.=0A=0A=
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A driver=
s/net/wireless/rsi/rsi_91x_mac80211.c | 30 +++++++++------------=0A 1 file =
changed, 12 insertions(+), 18 deletions(-)=0A=0Adiff --git a/drivers/net/wi=
reless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c=
=0Aindex ce5e92d82efc..3f5e3c234ee4 100644=0A--- a/drivers/net/wireless/rsi=
/rsi_91x_mac80211.c=0A+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c=0A@=
@ -188,27 +188,27 @@ bool rsi_is_cipher_wep(struct rsi_common *common)=0A  =
* @adapter: Pointer to the adapter structure.=0A  * @band: Operating band t=
o be set.=0A  *=0A- * Return: int - 0 on success, negative error on failure=
=2E=0A+ * Return: None.=0A  */=0A-static int rsi_register_rates_channels(st=
ruct rsi_hw *adapter, int band)=0A+static void rsi_register_rates_channels(=
struct rsi_hw *adapter, int band)=0A {=0A 	struct ieee80211_supported_band =
*sbands =3D &adapter->sbands[band];=0A 	void *channels =3D NULL;=0A =0A 	if=
 (band =3D=3D NL80211_BAND_2GHZ) {=0A-		channels =3D kmemdup(rsi_2ghz_chann=
els, sizeof(rsi_2ghz_channels),=0A-				   GFP_KERNEL);=0A-		if (!channels)=
=0A-			return -ENOMEM;=0A+		channels =3D kmalloc(sizeof(rsi_2ghz_channels),=
 GFP_KERNEL);=0A+		memcpy(channels,=0A+		       rsi_2ghz_channels,=0A+		   =
    sizeof(rsi_2ghz_channels));=0A 		sbands->band =3D NL80211_BAND_2GHZ;=0A=
 		sbands->n_channels =3D ARRAY_SIZE(rsi_2ghz_channels);=0A 		sbands->bitra=
tes =3D rsi_rates;=0A 		sbands->n_bitrates =3D ARRAY_SIZE(rsi_rates);=0A 	}=
 else {=0A-		channels =3D kmemdup(rsi_5ghz_channels, sizeof(rsi_5ghz_channe=
ls),=0A-				   GFP_KERNEL);=0A-		if (!channels)=0A-			return -ENOMEM;=0A+		=
channels =3D kmalloc(sizeof(rsi_5ghz_channels), GFP_KERNEL);=0A+		memcpy(ch=
annels,=0A+		       rsi_5ghz_channels,=0A+		       sizeof(rsi_5ghz_channels=
));=0A 		sbands->band =3D NL80211_BAND_5GHZ;=0A 		sbands->n_channels =3D AR=
RAY_SIZE(rsi_5ghz_channels);=0A 		sbands->bitrates =3D &rsi_rates[4];=0A@@ =
-227,7 +227,6 @@ static int rsi_register_rates_channels(struct rsi_hw *adap=
ter, int band)=0A 	sbands->ht_cap.mcs.rx_mask[0] =3D 0xff;=0A 	sbands->ht_c=
ap.mcs.tx_params =3D IEEE80211_HT_MCS_TX_DEFINED;=0A 	/* sbands->ht_cap.mcs=
=2Erx_highest =3D 0x82; */=0A-	return 0;=0A }=0A =0A static int rsi_mac8021=
1_hw_scan_start(struct ieee80211_hw *hw,=0A@@ -2066,16 +2065,11 @@ int rsi_=
mac80211_attach(struct rsi_common *common)=0A 	wiphy->available_antennas_rx=
 =3D 1;=0A 	wiphy->available_antennas_tx =3D 1;=0A =0A-	status =3D rsi_regi=
ster_rates_channels(adapter, NL80211_BAND_2GHZ);=0A-	if (status)=0A-		retur=
n status;=0A+	rsi_register_rates_channels(adapter, NL80211_BAND_2GHZ);=0A 	=
wiphy->bands[NL80211_BAND_2GHZ] =3D=0A 		&adapter->sbands[NL80211_BAND_2GHZ=
];=0A 	if (common->num_supp_bands > 1) {=0A-		status =3D rsi_register_rates=
_channels(adapter,=0A-						     NL80211_BAND_5GHZ);=0A-		if (status)=0A-		=
	return status;=0A+		rsi_register_rates_channels(adapter, NL80211_BAND_5GHZ=
);=0A 		wiphy->bands[NL80211_BAND_5GHZ] =3D=0A 			&adapter->sbands[NL80211_=
BAND_5GHZ];=0A 	}=0A-- =0A2.30.2=0A=0A=0AFrom fb092c1891f0ef43c5879db42ce6a=
9c175f42d55 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukher=
jee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:23:40 +0100=0ASubject: [PATCH 00=
7/151] Revert "net: cw1200: fix a NULL pointer dereference"=0A=0AThis rever=
ts commit 0ed2a005347400500a39ea7c7318f1fea57fb3ca.=0A=0ACommits from @umn.=
edu addresses have been found to be submitted in "bad=0Afaith" to try to te=
st the kernel community's ability to review "known=0Amalicious" changes.  T=
he result of these submissions can be found in a=0Apaper published at the 4=
2nd IEEE Symposium on Security and Privacy=0Aentitled, "Open Source Insecur=
ity: Stealthily Introducing=0AVulnerabilities via Hypocrite Commits" writte=
n by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (University of Mi=
nnesota).=0A=0ABecause of this, all submissions from this group must be rev=
erted from=0Athe kernel tree and will need to be re-reviewed again to deter=
mine if=0Athey actually are a valid fix.  Until that work is complete, remo=
ve this=0Achange to ensure that no problems are being introduced into the=
=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.co=
m>=0A---=0A drivers/net/wireless/st/cw1200/main.c | 5 -----=0A 1 file chang=
ed, 5 deletions(-)=0A=0Adiff --git a/drivers/net/wireless/st/cw1200/main.c =
b/drivers/net/wireless/st/cw1200/main.c=0Aindex 326b1cc1d2bc..015dd202e758 =
100644=0A--- a/drivers/net/wireless/st/cw1200/main.c=0A+++ b/drivers/net/wi=
reless/st/cw1200/main.c=0A@@ -342,11 +342,6 @@ static struct ieee80211_hw *=
cw1200_init_common(const u8 *macaddr,=0A 	mutex_init(&priv->wsm_cmd_mux);=
=0A 	mutex_init(&priv->conf_mutex);=0A 	priv->workqueue =3D create_singleth=
read_workqueue("cw1200_wq");=0A-	if (!priv->workqueue) {=0A-		ieee80211_fre=
e_hw(hw);=0A-		return NULL;=0A-	}=0A-=0A 	sema_init(&priv->scan.lock, 1);=
=0A 	INIT_WORK(&priv->scan.work, cw1200_scan_work);=0A 	INIT_DELAYED_WORK(&=
priv->scan.probe_work, cw1200_probe_work);=0A-- =0A2.30.2=0A=0A=0AFrom f0d0=
45cf4114585e8bf3ec91161da286ec1896c6 Mon Sep 17 00:00:00 2001=0AFrom: Sudip=
 Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:23:40 +=
0100=0ASubject: [PATCH 008/151] Revert "net: ieee802154: fix missing checks=
 for=0A regmap_update_bits"=0A=0AThis reverts commit 22e8860cf8f777fbf6a83f=
2fb7127f682a8e9de4.=0A=0ACommits from @umn.edu addresses have been found to=
 be submitted in "bad=0Afaith" to try to test the kernel community's abilit=
y to review "known=0Amalicious" changes.  The result of these submissions c=
an be found in a=0Apaper published at the 42nd IEEE Symposium on Security a=
nd Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVu=
lnerabilities via Hypocrite Commits" written by Qiushi Wu (University=0Aof =
Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, =
all submissions from this group must be reverted from=0Athe kernel tree and=
 will need to be re-reviewed again to determine if=0Athey actually are a va=
lid fix.  Until that work is complete, remove this=0Achange to ensure that =
no problems are being introduced into the=0Acodebase.=0A=0ASigned-off-by: S=
udip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/ieee802154=
/mcr20a.c | 6 ------=0A 1 file changed, 6 deletions(-)=0A=0Adiff --git a/dr=
ivers/net/ieee802154/mcr20a.c b/drivers/net/ieee802154/mcr20a.c=0Aindex 8dc=
04e2590b1..2ce5b41983f8 100644=0A--- a/drivers/net/ieee802154/mcr20a.c=0A++=
+ b/drivers/net/ieee802154/mcr20a.c=0A@@ -524,8 +524,6 @@ mcr20a_start(stru=
ct ieee802154_hw *hw)=0A 	dev_dbg(printdev(lp), "no slotted operation\n");=
=0A 	ret =3D regmap_update_bits(lp->regmap_dar, DAR_PHY_CTRL1,=0A 				 DAR_=
PHY_CTRL1_SLOTTED, 0x0);=0A-	if (ret < 0)=0A-		return ret;=0A =0A 	/* enabl=
e irq */=0A 	enable_irq(lp->spi->irq);=0A@@ -533,15 +531,11 @@ mcr20a_start=
(struct ieee802154_hw *hw)=0A 	/* Unmask SEQ interrupt */=0A 	ret =3D regma=
p_update_bits(lp->regmap_dar, DAR_PHY_CTRL2,=0A 				 DAR_PHY_CTRL2_SEQMSK, =
0x0);=0A-	if (ret < 0)=0A-		return ret;=0A =0A 	/* Start the RX sequence */=
=0A 	dev_dbg(printdev(lp), "start the RX sequence\n");=0A 	ret =3D regmap_u=
pdate_bits(lp->regmap_dar, DAR_PHY_CTRL1,=0A 				 DAR_PHY_CTRL1_XCVSEQ_MASK=
, MCR20A_XCVSEQ_RX);=0A-	if (ret < 0)=0A-		return ret;=0A =0A 	return 0;=0A=
 }=0A-- =0A2.30.2=0A=0A=0AFrom 3cc87347c2515a57cad370e38a028933b71b528e Mon=
 Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=
=0ADate: Wed, 21 Apr 2021 20:23:41 +0100=0ASubject: [PATCH 009/151] Revert =
"x86/PCI: Fix PCI IRQ routing table memory=0A leak"=0A=0AThis reverts commi=
t ea094d53580f40c2124cef3d072b73b2425e7bfd.=0A=0ACommits from @umn.edu addr=
esses have been found to be submitted in "bad=0Afaith" to try to test the k=
ernel community's ability to review "known=0Amalicious" changes.  The resul=
t of these submissions can be found in a=0Apaper published at the 42nd IEEE=
 Symposium on Security and Privacy=0Aentitled, "Open Source Insecurity: Ste=
althily Introducing=0AVulnerabilities via Hypocrite Commits" written by Qiu=
shi Wu (University=0Aof Minnesota) and Kangjie Lu (University of Minnesota)=
=2E=0A=0ABecause of this, all submissions from this group must be reverted =
=66rom=0Athe kernel tree and will need to be re-reviewed again to determine=
 if=0Athey actually are a valid fix.  Until that work is complete, remove t=
his=0Achange to ensure that no problems are being introduced into the=0Acod=
ebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A-=
--=0A arch/x86/pci/irq.c | 10 ++--------=0A 1 file changed, 2 insertions(+)=
, 8 deletions(-)=0A=0Adiff --git a/arch/x86/pci/irq.c b/arch/x86/pci/irq.c=
=0Aindex d3a73f9335e1..52e55108404e 100644=0A--- a/arch/x86/pci/irq.c=0A+++=
 b/arch/x86/pci/irq.c=0A@@ -1119,8 +1119,6 @@ static const struct dmi_syste=
m_id pciirq_dmi_table[] __initconst =3D {=0A =0A void __init pcibios_irq_in=
it(void)=0A {=0A-	struct irq_routing_table *rtable =3D NULL;=0A-=0A 	DBG(KE=
RN_DEBUG "PCI: IRQ init\n");=0A =0A 	if (raw_pci_ops =3D=3D NULL)=0A@@ -113=
1,10 +1129,8 @@ void __init pcibios_irq_init(void)=0A 	pirq_table =3D pirq_=
find_routing_table();=0A =0A #ifdef CONFIG_PCI_BIOS=0A-	if (!pirq_table && =
(pci_probe & PCI_BIOS_IRQ_SCAN)) {=0A+	if (!pirq_table && (pci_probe & PCI_=
BIOS_IRQ_SCAN))=0A 		pirq_table =3D pcibios_get_irq_routing_table();=0A-		r=
table =3D pirq_table;=0A-	}=0A #endif=0A 	if (pirq_table) {=0A 		pirq_peer_=
trick();=0A@@ -1149,10 +1145,8 @@ void __init pcibios_irq_init(void)=0A 		 =
* If we're using the I/O APIC, avoid using the PCI IRQ=0A 		 * routing tabl=
e=0A 		 */=0A-		if (io_apic_assign_pci_irqs) {=0A-			kfree(rtable);=0A+		if=
 (io_apic_assign_pci_irqs)=0A 			pirq_table =3D NULL;=0A-		}=0A 	}=0A =0A 	=
x86_init.pci.fixup_irqs();=0A-- =0A2.30.2=0A=0A=0AFrom 6f37a61e0e180dced5e0=
2493768539cf342fab25 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudi=
pm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:23:41 +0100=0ASubject: =
[PATCH 010/151] Revert "udf: fix an uninitialized read bug and remove=0A de=
ad code"=0A=0AThis reverts commit 39416c5872db69859e867fa250b9cbb3f1e0d185.=
=0A=0ACommits from @umn.edu addresses have been found to be submitted in "b=
ad=0Afaith" to try to test the kernel community's ability to review "known=
=0Amalicious" changes.  The result of these submissions can be found in a=
=0Apaper published at the 42nd IEEE Symposium on Security and Privacy=0Aent=
itled, "Open Source Insecurity: Stealthily Introducing=0AVulnerabilities vi=
a Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnesota) and K=
angjie Lu (University of Minnesota).=0A=0ABecause of this, all submissions =
=66rom this group must be reverted from=0Athe kernel tree and will need to =
be re-reviewed again to determine if=0Athey actually are a valid fix.  Unti=
l that work is complete, remove this=0Achange to ensure that no problems ar=
e being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee=
 <sudipm.mukherjee@gmail.com>=0A---=0A fs/udf/namei.c | 15 +++++++++++++++=
=0A 1 file changed, 15 insertions(+)=0A=0Adiff --git a/fs/udf/namei.c b/fs/=
udf/namei.c=0Aindex 77b6d89b9bcd..58cc2414992b 100644=0A--- a/fs/udf/namei.=
c=0A+++ b/fs/udf/namei.c=0A@@ -304,6 +304,21 @@ static struct dentry *udf_l=
ookup(struct inode *dir, struct dentry *dentry,=0A 	if (dentry->d_name.len =
> UDF_NAME_LEN)=0A 		return ERR_PTR(-ENAMETOOLONG);=0A =0A+#ifdef UDF_RECOV=
ERY=0A+	/* temporary shorthand for specifying files by inode number */=0A+	=
if (!strncmp(dentry->d_name.name, ".B=3D", 3)) {=0A+		struct kernel_lb_addr=
 lb =3D {=0A+			.logicalBlockNum =3D 0,=0A+			.partitionReferenceNum =3D=0A=
+				simple_strtoul(dentry->d_name.name + 3,=0A+						NULL, 0),=0A+		};=0A+=
		inode =3D udf_iget(dir->i_sb, lb);=0A+		if (IS_ERR(inode))=0A+			return i=
node;=0A+	} else=0A+#endif /* UDF_RECOVERY */=0A+=0A 	fi =3D udf_find_entry=
(dir, &dentry->d_name, &fibh, &cfi);=0A 	if (IS_ERR(fi))=0A 		return ERR_CA=
ST(fi);=0A-- =0A2.30.2=0A=0A=0AFrom 7ba2a0a4d686552daf025027bf22e4f3fe60b47=
4 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.=
com>=0ADate: Wed, 21 Apr 2021 20:23:42 +0100=0ASubject: [PATCH 011/151] Rev=
ert "mmc_spi: add a status check for=0A spi_sync_locked"=0A=0AThis reverts =
commit 611025983b7976df0183390a63a2166411d177f1.=0A=0ACommits from @umn.edu=
 addresses have been found to be submitted in "bad=0Afaith" to try to test =
the kernel community's ability to review "known=0Amalicious" changes.  The =
result of these submissions can be found in a=0Apaper published at the 42nd=
 IEEE Symposium on Security and Privacy=0Aentitled, "Open Source Insecurity=
: Stealthily Introducing=0AVulnerabilities via Hypocrite Commits" written b=
y Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (University of Minne=
sota).=0A=0ABecause of this, all submissions from this group must be revert=
ed from=0Athe kernel tree and will need to be re-reviewed again to determin=
e if=0Athey actually are a valid fix.  Until that work is complete, remove =
this=0Achange to ensure that no problems are being introduced into the=0Aco=
debase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A=
---=0A drivers/mmc/host/mmc_spi.c | 4 ----=0A 1 file changed, 4 deletions(-=
)=0A=0Adiff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c=
=0Aindex 7083d8ddd495..8a503ac361e1 100644=0A--- a/drivers/mmc/host/mmc_spi=
=2Ec=0A+++ b/drivers/mmc/host/mmc_spi.c=0A@@ -802,10 +802,6 @@ mmc_spi_read=
block(struct mmc_spi_host *host, struct spi_transfer *t,=0A 	}=0A =0A 	stat=
us =3D spi_sync_locked(spi, &host->m);=0A-	if (status < 0) {=0A-		dev_dbg(&=
spi->dev, "read error %d\n", status);=0A-		return status;=0A-	}=0A =0A 	if =
(host->dma_dev) {=0A 		dma_sync_single_for_cpu(host->dma_dev,=0A-- =0A2.30.=
2=0A=0A=0AFrom 54332130f3a5b6c07d0e80e4e83e0bcf853cb5d9 Mon Sep 17 00:00:00=
 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 =
Apr 2021 20:23:42 +0100=0ASubject: [PATCH 012/151] Revert "PCI: endpoint: F=
ix a potential NULL pointer=0A dereference"=0A=0AThis reverts commit 507b82=
0009a457afa78202da337bcb56791fbb12.=0A=0ACommits from @umn.edu addresses ha=
ve been found to be submitted in "bad=0Afaith" to try to test the kernel co=
mmunity's ability to review "known=0Amalicious" changes.  The result of the=
se submissions can be found in a=0Apaper published at the 42nd IEEE Symposi=
um on Security and Privacy=0Aentitled, "Open Source Insecurity: Stealthily =
Introducing=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu (=
University=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=0AB=
ecause of this, all submissions from this group must be reverted from=0Athe=
 kernel tree and will need to be re-reviewed again to determine if=0Athey a=
ctually are a valid fix.  Until that work is complete, remove this=0Achange=
 to ensure that no problems are being introduced into the=0Acodebase.=0A=0A=
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A driver=
s/pci/endpoint/functions/pci-epf-test.c | 5 -----=0A 1 file changed, 5 dele=
tions(-)=0A=0Adiff --git a/drivers/pci/endpoint/functions/pci-epf-test.c b/=
drivers/pci/endpoint/functions/pci-epf-test.c=0Aindex 1cfe3687a211..4cae273=
64fcd 100644=0A--- a/drivers/pci/endpoint/functions/pci-epf-test.c=0A+++ b/=
drivers/pci/endpoint/functions/pci-epf-test.c=0A@@ -597,11 +597,6 @@ static=
 int __init pci_epf_test_init(void)=0A =0A 	kpcitest_workqueue =3D alloc_wo=
rkqueue("kpcitest",=0A 					     WQ_MEM_RECLAIM | WQ_HIGHPRI, 0);=0A-	if (!=
kpcitest_workqueue) {=0A-		pr_err("Failed to allocate the kpcitest work que=
ue\n");=0A-		return -ENOMEM;=0A-	}=0A-=0A 	ret =3D pci_epf_register_driver(=
&test_driver);=0A 	if (ret) {=0A 		pr_err("Failed to register pci epf test =
driver --> %d\n", ret);=0A-- =0A2.30.2=0A=0A=0AFrom edf503a77a2eadfc68cdfe7=
9b8fa71923ac0eb80 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.=
mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:23:43 +0100=0ASubject: [PA=
TCH 013/151] Revert "net/smc: fix a NULL pointer dereference"=0A=0AThis rev=
erts commit e183d4e414b64711baf7a04e214b61969ca08dfa.=0A=0ACommits from @um=
n.edu addresses have been found to be submitted in "bad=0Afaith" to try to =
test the kernel community's ability to review "known=0Amalicious" changes. =
 The result of these submissions can be found in a=0Apaper published at the=
 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Open Source Insec=
urity: Stealthily Introducing=0AVulnerabilities via Hypocrite Commits" writ=
ten by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (University of =
Minnesota).=0A=0ABecause of this, all submissions from this group must be r=
everted from=0Athe kernel tree and will need to be re-reviewed again to det=
ermine if=0Athey actually are a valid fix.  Until that work is complete, re=
move this=0Achange to ensure that no problems are being introduced into the=
=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.co=
m>=0A---=0A net/smc/smc_ism.c | 5 -----=0A 1 file changed, 5 deletions(-)=
=0A=0Adiff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c=0Aindex e89e918b88=
e0..2fff79db1a59 100644=0A--- a/net/smc/smc_ism.c=0A+++ b/net/smc/smc_ism.c=
=0A@@ -289,11 +289,6 @@ struct smcd_dev *smcd_alloc_dev(struct device *pare=
nt, const char *name,=0A 	INIT_LIST_HEAD(&smcd->vlan);=0A 	smcd->event_wq =
=3D alloc_ordered_workqueue("ism_evt_wq-%s)",=0A 						 WQ_MEM_RECLAIM, nam=
e);=0A-	if (!smcd->event_wq) {=0A-		kfree(smcd->conn);=0A-		kfree(smcd);=0A=
-		return NULL;=0A-	}=0A 	return smcd;=0A }=0A EXPORT_SYMBOL_GPL(smcd_alloc=
_dev);=0A-- =0A2.30.2=0A=0A=0AFrom a5bbe23b879ec18c5d49663c71b6436ef4108c78=
 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.c=
om>=0ADate: Wed, 21 Apr 2021 20:23:43 +0100=0ASubject: [PATCH 014/151] Reve=
rt "pinctrl: axp209: Fix NULL pointer dereference=0A after allocation"=0A=
=0AThis reverts commit 1adc90c7395742827d754a5f02f446818a77c379.=0A=0ACommi=
ts from @umn.edu addresses have been found to be submitted in "bad=0Afaith"=
 to try to test the kernel community's ability to review "known=0Amalicious=
" changes.  The result of these submissions can be found in a=0Apaper publi=
shed at the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Open S=
ource Insecurity: Stealthily Introducing=0AVulnerabilities via Hypocrite Co=
mmits" written by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (Uni=
versity of Minnesota).=0A=0ABecause of this, all submissions from this grou=
p must be reverted from=0Athe kernel tree and will need to be re-reviewed a=
gain to determine if=0Athey actually are a valid fix.  Until that work is c=
omplete, remove this=0Achange to ensure that no problems are being introduc=
ed into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherj=
ee@gmail.com>=0A---=0A drivers/pinctrl/pinctrl-axp209.c | 2 --=0A 1 file ch=
anged, 2 deletions(-)=0A=0Adiff --git a/drivers/pinctrl/pinctrl-axp209.c b/=
drivers/pinctrl/pinctrl-axp209.c=0Aindex be5b645815e5..c1b8e1e1e62b 100644=
=0A--- a/drivers/pinctrl/pinctrl-axp209.c=0A+++ b/drivers/pinctrl/pinctrl-a=
xp209.c=0A@@ -362,8 +362,6 @@ static int axp20x_build_funcs_groups(struct p=
latform_device *pdev)=0A 		pctl->funcs[i].groups =3D devm_kcalloc(&pdev->de=
v,=0A 						     npins, sizeof(char *),=0A 						     GFP_KERNEL);=0A-		if =
(!pctl->funcs[i].groups)=0A-			return -ENOMEM;=0A 		for (pin =3D 0; pin < n=
pins; pin++)=0A 			pctl->funcs[i].groups[pin] =3D pctl->desc->pins[pin].nam=
e;=0A 	}=0A-- =0A2.30.2=0A=0A=0AFrom 150686b226a7da61b7d141274e13d47987f116=
07 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail=
=2Ecom>=0ADate: Wed, 21 Apr 2021 20:23:44 +0100=0ASubject: [PATCH 015/151] =
Revert "iio: hmc5843: fix potential NULL pointer=0A dereferences"=0A=0AThis=
 reverts commit 536cc27deade8f1ec3c1beefa60d5fbe0f6fcb28.=0A=0ACommits from=
 @umn.edu addresses have been found to be submitted in "bad=0Afaith" to try=
 to test the kernel community's ability to review "known=0Amalicious" chang=
es.  The result of these submissions can be found in a=0Apaper published at=
 the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Open Source I=
nsecurity: Stealthily Introducing=0AVulnerabilities via Hypocrite Commits" =
written by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (University=
 of Minnesota).=0A=0ABecause of this, all submissions from this group must =
be reverted from=0Athe kernel tree and will need to be re-reviewed again to=
 determine if=0Athey actually are a valid fix.  Until that work is complete=
, remove this=0Achange to ensure that no problems are being introduced into=
 the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmai=
l.com>=0A---=0A drivers/iio/magnetometer/hmc5843_i2c.c | 7 +------=0A drive=
rs/iio/magnetometer/hmc5843_spi.c | 7 +------=0A 2 files changed, 2 inserti=
ons(+), 12 deletions(-)=0A=0Adiff --git a/drivers/iio/magnetometer/hmc5843_=
i2c.c b/drivers/iio/magnetometer/hmc5843_i2c.c=0Aindex 67fe657fdb3e..9a4491=
233d08 100644=0A--- a/drivers/iio/magnetometer/hmc5843_i2c.c=0A+++ b/driver=
s/iio/magnetometer/hmc5843_i2c.c=0A@@ -55,13 +55,8 @@ static const struct r=
egmap_config hmc5843_i2c_regmap_config =3D {=0A static int hmc5843_i2c_prob=
e(struct i2c_client *cli,=0A 			     const struct i2c_device_id *id)=0A {=
=0A-	struct regmap *regmap =3D devm_regmap_init_i2c(cli,=0A-			&hmc5843_i2c=
_regmap_config);=0A-	if (IS_ERR(regmap))=0A-		return PTR_ERR(regmap);=0A-=
=0A 	return hmc5843_common_probe(&cli->dev,=0A-			regmap,=0A+			devm_regmap=
_init_i2c(cli, &hmc5843_i2c_regmap_config),=0A 			id->driver_data, id->name=
);=0A }=0A =0Adiff --git a/drivers/iio/magnetometer/hmc5843_spi.c b/drivers=
/iio/magnetometer/hmc5843_spi.c=0Aindex d827554c346e..58bdbc7257ec 100644=
=0A--- a/drivers/iio/magnetometer/hmc5843_spi.c=0A+++ b/drivers/iio/magneto=
meter/hmc5843_spi.c=0A@@ -55,7 +55,6 @@ static const struct regmap_config h=
mc5843_spi_regmap_config =3D {=0A static int hmc5843_spi_probe(struct spi_d=
evice *spi)=0A {=0A 	int ret;=0A-	struct regmap *regmap;=0A 	const struct s=
pi_device_id *id =3D spi_get_device_id(spi);=0A =0A 	spi->mode =3D SPI_MODE=
_3;=0A@@ -65,12 +64,8 @@ static int hmc5843_spi_probe(struct spi_device *sp=
i)=0A 	if (ret)=0A 		return ret;=0A =0A-	regmap =3D devm_regmap_init_spi(sp=
i, &hmc5843_spi_regmap_config);=0A-	if (IS_ERR(regmap))=0A-		return PTR_ERR=
(regmap);=0A-=0A 	return hmc5843_common_probe(&spi->dev,=0A-			regmap,=0A+	=
		devm_regmap_init_spi(spi, &hmc5843_spi_regmap_config),=0A 			id->driver_d=
ata, id->name);=0A }=0A =0A-- =0A2.30.2=0A=0A=0AFrom d1bb8b9076494dc0863b85=
01d4ac2c40112be706 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm=
=2Emukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:23:44 +0100=0ASubject: =
[PATCH 016/151] Revert "iio: adc: fix a potential NULL pointer=0A dereferen=
ce"=0A=0AThis reverts commit 13814627c9658cf8382dd052bc251ee415670a55.=0A=
=0ACommits from @umn.edu addresses have been found to be submitted in "bad=
=0Afaith" to try to test the kernel community's ability to review "known=0A=
malicious" changes.  The result of these submissions can be found in a=0Apa=
per published at the 42nd IEEE Symposium on Security and Privacy=0Aentitled=
, "Open Source Insecurity: Stealthily Introducing=0AVulnerabilities via Hyp=
ocrite Commits" written by Qiushi Wu (University=0Aof Minnesota) and Kangji=
e Lu (University of Minnesota).=0A=0ABecause of this, all submissions from =
this group must be reverted from=0Athe kernel tree and will need to be re-r=
eviewed again to determine if=0Athey actually are a valid fix.  Until that =
work is complete, remove this=0Achange to ensure that no problems are being=
 introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudip=
m.mukherjee@gmail.com>=0A---=0A drivers/iio/adc/mxs-lradc-adc.c | 2 --=0A 1=
 file changed, 2 deletions(-)=0A=0Adiff --git a/drivers/iio/adc/mxs-lradc-a=
dc.c b/drivers/iio/adc/mxs-lradc-adc.c=0Aindex 9d2f74c2489a..d2af1e21afc8 1=
00644=0A--- a/drivers/iio/adc/mxs-lradc-adc.c=0A+++ b/drivers/iio/adc/mxs-l=
radc-adc.c=0A@@ -456,8 +456,6 @@ static int mxs_lradc_adc_trigger_init(stru=
ct iio_dev *iio)=0A =0A 	trig =3D devm_iio_trigger_alloc(&iio->dev, "%s-dev=
%i", iio->name,=0A 				      iio->id);=0A-	if (!trig)=0A-		return -ENOMEM;=
=0A =0A 	trig->dev.parent =3D adc->dev;=0A 	iio_trigger_set_drvdata(trig, i=
io);=0A-- =0A2.30.2=0A=0A=0AFrom 5c74538e8a6d1ca429761acd59c69cf9f9dece91 M=
on Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com=
>=0ADate: Wed, 21 Apr 2021 20:23:44 +0100=0ASubject: [PATCH 017/151] Revert=
 "net: mwifiex: fix a NULL pointer dereference"=0A=0AThis reverts commit e5=
b9b206f3f6376b9a1406b67eafe4e7bb9f123c.=0A=0ACommits from @umn.edu addresse=
s have been found to be submitted in "bad=0Afaith" to try to test the kerne=
l community's ability to review "known=0Amalicious" changes.  The result of=
 these submissions can be found in a=0Apaper published at the 42nd IEEE Sym=
posium on Security and Privacy=0Aentitled, "Open Source Insecurity: Stealth=
ily Introducing=0AVulnerabilities via Hypocrite Commits" written by Qiushi =
Wu (University=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=
=0ABecause of this, all submissions from this group must be reverted from=
=0Athe kernel tree and will need to be re-reviewed again to determine if=0A=
they actually are a valid fix.  Until that work is complete, remove this=0A=
change to ensure that no problems are being introduced into the=0Acodebase.=
=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A =
drivers/net/wireless/marvell/mwifiex/cmdevt.c | 6 ------=0A 1 file changed,=
 6 deletions(-)=0A=0Adiff --git a/drivers/net/wireless/marvell/mwifiex/cmde=
vt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c=0Aindex e8788c35a453..=
bb9d4371345b 100644=0A--- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c=
=0A+++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c=0A@@ -339,12 +339,6 =
@@ static int mwifiex_dnld_sleep_confirm_cmd(struct mwifiex_adapter *adapte=
r)=0A 		sleep_cfm_tmp =3D=0A 			dev_alloc_skb(sizeof(struct mwifiex_opt_sle=
ep_confirm)=0A 				      + MWIFIEX_TYPE_LEN);=0A-		if (!sleep_cfm_tmp) {=0A=
-			mwifiex_dbg(adapter, ERROR,=0A-				    "SLEEP_CFM: dev_alloc_skb failed=
\n");=0A-			return -ENOMEM;=0A-		}=0A-=0A 		skb_put(sleep_cfm_tmp, sizeof(s=
truct mwifiex_opt_sleep_confirm)=0A 			+ MWIFIEX_TYPE_LEN);=0A 		put_unalig=
ned_le32(MWIFIEX_USB_TYPE_CMD, sleep_cfm_tmp->data);=0A-- =0A2.30.2=0A=0A=
=0AFrom 4d01bd88673c27124ebd40585b44ea3a00b4951d Mon Sep 17 00:00:00 2001=
=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2=
021 20:23:45 +0100=0ASubject: [PATCH 018/151] Revert "rtlwifi: fix a potent=
ial NULL pointer=0A dereference"=0A=0AThis reverts commit 765976285a8c8db3f=
0eb7f033829a899d0c2786e.=0A=0ACommits from @umn.edu addresses have been fou=
nd to be submitted in "bad=0Afaith" to try to test the kernel community's a=
bility to review "known=0Amalicious" changes.  The result of these submissi=
ons can be found in a=0Apaper published at the 42nd IEEE Symposium on Secur=
ity and Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=
=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu (University=
=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of =
this, all submissions from this group must be reverted from=0Athe kernel tr=
ee and will need to be re-reviewed again to determine if=0Athey actually ar=
e a valid fix.  Until that work is complete, remove this=0Achange to ensure=
 that no problems are being introduced into the=0Acodebase.=0A=0ASigned-off=
-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/wire=
less/realtek/rtlwifi/base.c | 5 -----=0A 1 file changed, 5 deletions(-)=0A=
=0Adiff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/w=
ireless/realtek/rtlwifi/base.c=0Aindex ac746c322554..217d2a7a43c7 100644=0A=
--- a/drivers/net/wireless/realtek/rtlwifi/base.c=0A+++ b/drivers/net/wirel=
ess/realtek/rtlwifi/base.c=0A@@ -448,11 +448,6 @@ static void _rtl_init_def=
erred_work(struct ieee80211_hw *hw)=0A 	/* <2> work queue */=0A 	rtlpriv->w=
orks.hw =3D hw;=0A 	rtlpriv->works.rtl_wq =3D alloc_workqueue("%s", 0, 0, r=
tlpriv->cfg->name);=0A-	if (unlikely(!rtlpriv->works.rtl_wq)) {=0A-		pr_err=
("Failed to allocate work queue\n");=0A-		return;=0A-	}=0A-=0A 	INIT_DELAYE=
D_WORK(&rtlpriv->works.watchdog_wq,=0A 			  (void *)rtl_watchdog_wq_callbac=
k);=0A 	INIT_DELAYED_WORK(&rtlpriv->works.ips_nic_off_wq,=0A-- =0A2.30.2=0A=
=0A=0AFrom 53eb88f1ef25e64db7372a5e37f8df5c0a648ff7 Mon Sep 17 00:00:00 200=
1=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr =
2021 20:23:45 +0100=0ASubject: [PATCH 019/151] Revert "video: hgafb: fix po=
tential NULL pointer=0A dereference"=0A=0AThis reverts commit ec7f6aad57ad2=
9e4e66cc2e18e1e1599ddb02542.=0A=0ACommits from @umn.edu addresses have been=
 found to be submitted in "bad=0Afaith" to try to test the kernel community=
's ability to review "known=0Amalicious" changes.  The result of these subm=
issions can be found in a=0Apaper published at the 42nd IEEE Symposium on S=
ecurity and Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introdu=
cing=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu (Univers=
ity=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause =
of this, all submissions from this group must be reverted from=0Athe kernel=
 tree and will need to be re-reviewed again to determine if=0Athey actually=
 are a valid fix.  Until that work is complete, remove this=0Achange to ens=
ure that no problems are being introduced into the=0Acodebase.=0A=0ASigned-=
off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/video=
/fbdev/hgafb.c | 2 --=0A 1 file changed, 2 deletions(-)=0A=0Adiff --git a/d=
rivers/video/fbdev/hgafb.c b/drivers/video/fbdev/hgafb.c=0Aindex 59e1cae579=
48..463028543173 100644=0A--- a/drivers/video/fbdev/hgafb.c=0A+++ b/drivers=
/video/fbdev/hgafb.c=0A@@ -285,8 +285,6 @@ static int hga_card_detect(void)=
=0A 	hga_vram_len  =3D 0x08000;=0A =0A 	hga_vram =3D ioremap(0xb0000, hga_v=
ram_len);=0A-	if (!hga_vram)=0A-		goto error;=0A =0A 	if (request_region(0x=
3b0, 12, "hgafb"))=0A 		release_io_ports =3D 1;=0A-- =0A2.30.2=0A=0A=0AFrom=
 2b42bdce890729ed16fa9d4affc9f849593c3a1d Mon Sep 17 00:00:00 2001=0AFrom: =
Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:23=
:46 +0100=0ASubject: [PATCH 020/151] Revert "video: imsttfb: fix potential =
NULL pointer=0A dereferences"=0A=0AThis reverts commit 1d84353d205a953e2381=
044953b7fa31c8c9702d.=0A=0ACommits from @umn.edu addresses have been found =
to be submitted in "bad=0Afaith" to try to test the kernel community's abil=
ity to review "known=0Amalicious" changes.  The result of these submissions=
 can be found in a=0Apaper published at the 42nd IEEE Symposium on Security=
 and Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0A=
Vulnerabilities via Hypocrite Commits" written by Qiushi Wu (University=0Ao=
f Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this=
, all submissions from this group must be reverted from=0Athe kernel tree a=
nd will need to be re-reviewed again to determine if=0Athey actually are a =
valid fix.  Until that work is complete, remove this=0Achange to ensure tha=
t no problems are being introduced into the=0Acodebase.=0A=0ASigned-off-by:=
 Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/video/fbdev/=
imsttfb.c | 5 -----=0A 1 file changed, 5 deletions(-)=0A=0Adiff --git a/dri=
vers/video/fbdev/imsttfb.c b/drivers/video/fbdev/imsttfb.c=0Aindex 58b01c7d=
9056..5f610d4929dd 100644=0A--- a/drivers/video/fbdev/imsttfb.c=0A+++ b/dri=
vers/video/fbdev/imsttfb.c=0A@@ -1512,11 +1512,6 @@ static int imsttfb_prob=
e(struct pci_dev *pdev, const struct pci_device_id *ent)=0A 	info->fix.smem=
_start =3D addr;=0A 	info->screen_base =3D (__u8 *)ioremap(addr, par->ramda=
c =3D=3D IBM ?=0A 					    0x400000 : 0x800000);=0A-	if (!info->screen_base=
) {=0A-		release_mem_region(addr, size);=0A-		framebuffer_release(info);=0A=
-		return -ENOMEM;=0A-	}=0A 	info->fix.mmio_start =3D addr + 0x800000;=0A 	=
par->dc_regs =3D ioremap(addr + 0x800000, 0x1000);=0A 	par->cmap_regs_phys =
=3D addr + 0x840000;=0A-- =0A2.30.2=0A=0A=0AFrom 1224718ee09579c3e710a426aa=
bf674faf5cd6d2 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.muk=
herjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:23:46 +0100=0ASubject: [PATCH=
 021/151] Revert "PCI: xilinx: Check for __get_free_pages()=0A failure"=0A=
=0AThis reverts commit 699ca30162686bf305cdf94861be02eb0cf9bda2.=0A=0ACommi=
ts from @umn.edu addresses have been found to be submitted in "bad=0Afaith"=
 to try to test the kernel community's ability to review "known=0Amalicious=
" changes.  The result of these submissions can be found in a=0Apaper publi=
shed at the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Open S=
ource Insecurity: Stealthily Introducing=0AVulnerabilities via Hypocrite Co=
mmits" written by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (Uni=
versity of Minnesota).=0A=0ABecause of this, all submissions from this grou=
p must be reverted from=0Athe kernel tree and will need to be re-reviewed a=
gain to determine if=0Athey actually are a valid fix.  Until that work is c=
omplete, remove this=0Achange to ensure that no problems are being introduc=
ed into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherj=
ee@gmail.com>=0A---=0A drivers/pci/controller/pcie-xilinx.c | 12 ++--------=
--=0A 1 file changed, 2 insertions(+), 10 deletions(-)=0A=0Adiff --git a/dr=
ivers/pci/controller/pcie-xilinx.c b/drivers/pci/controller/pcie-xilinx.c=
=0Aindex 5bf3af3b28e6..9bd1a35cd5d8 100644=0A--- a/drivers/pci/controller/p=
cie-xilinx.c=0A+++ b/drivers/pci/controller/pcie-xilinx.c=0A@@ -336,19 +336=
,14 @@ static const struct irq_domain_ops msi_domain_ops =3D {=0A  * xilinx=
_pcie_enable_msi - Enable MSI support=0A  * @port: PCIe port information=0A=
  */=0A-static int xilinx_pcie_enable_msi(struct xilinx_pcie_port *port)=0A=
+static void xilinx_pcie_enable_msi(struct xilinx_pcie_port *port)=0A {=0A =
	phys_addr_t msg_addr;=0A =0A 	port->msi_pages =3D __get_free_pages(GFP_KER=
NEL, 0);=0A-	if (!port->msi_pages)=0A-		return -ENOMEM;=0A-=0A 	msg_addr =
=3D virt_to_phys((void *)port->msi_pages);=0A 	pcie_write(port, 0x0, XILINX=
_PCIE_REG_MSIBASE1);=0A 	pcie_write(port, msg_addr, XILINX_PCIE_REG_MSIBASE=
2);=0A-=0A-	return 0;=0A }=0A =0A /* INTx Functions */=0A@@ -503,7 +498,6 @=
@ static int xilinx_pcie_init_irq_domain(struct xilinx_pcie_port *port)=0A =
	struct device *dev =3D port->dev;=0A 	struct device_node *node =3D dev->of=
_node;=0A 	struct device_node *pcie_intc_node;=0A-	int ret;=0A =0A 	/* Setu=
p INTx */=0A 	pcie_intc_node =3D of_get_next_child(node, NULL);=0A@@ -532,9=
 +526,7 @@ static int xilinx_pcie_init_irq_domain(struct xilinx_pcie_port *=
port)=0A 			return -ENODEV;=0A 		}=0A =0A-		ret =3D xilinx_pcie_enable_msi(=
port);=0A-		if (ret)=0A-			return ret;=0A+		xilinx_pcie_enable_msi(port);=
=0A 	}=0A =0A 	return 0;=0A-- =0A2.30.2=0A=0A=0AFrom acd8c23b478514f7f5d0ba=
c268bec2ef3052db2d Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm=
=2Emukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:23:47 +0100=0ASubject: =
[PATCH 022/151] Revert "staging: greybus: audio_manager: fix a=0A missing c=
heck of ida_simple_get"=0A=0AThis reverts commit b5af36e3e5aa074605a4d90a89=
dd8f714b30909b.=0A=0ACommits from @umn.edu addresses have been found to be =
submitted in "bad=0Afaith" to try to test the kernel community's ability to=
 review "known=0Amalicious" changes.  The result of these submissions can b=
e found in a=0Apaper published at the 42nd IEEE Symposium on Security and P=
rivacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVulner=
abilities via Hypocrite Commits" written by Qiushi Wu (University=0Aof Minn=
esota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, all =
submissions from this group must be reverted from=0Athe kernel tree and wil=
l need to be re-reviewed again to determine if=0Athey actually are a valid =
fix.  Until that work is complete, remove this=0Achange to ensure that no p=
roblems are being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip=
 Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/staging/greybus/au=
dio_manager.c | 3 ---=0A 1 file changed, 3 deletions(-)=0A=0Adiff --git a/d=
rivers/staging/greybus/audio_manager.c b/drivers/staging/greybus/audio_mana=
ger.c=0Aindex 9a3f7c034ab4..7c7ca671876d 100644=0A--- a/drivers/staging/gre=
ybus/audio_manager.c=0A+++ b/drivers/staging/greybus/audio_manager.c=0A@@ -=
45,9 +45,6 @@ int gb_audio_manager_add(struct gb_audio_manager_module_descr=
iptor *desc)=0A 	int err;=0A =0A 	id =3D ida_simple_get(&module_id, 0, 0, G=
FP_KERNEL);=0A-	if (id < 0)=0A-		return id;=0A-=0A 	err =3D gb_audio_manage=
r_module_create(&module, manager_kset,=0A 					     id, desc);=0A 	if (err)=
 {=0A-- =0A2.30.2=0A=0A=0AFrom 04ca5c347db99a3f286a77313d4e46e7d035bec1 Mon=
 Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=
=0ADate: Wed, 21 Apr 2021 20:23:47 +0100=0ASubject: [PATCH 023/151] Revert =
"omapfb: Fix potential NULL pointer=0A dereference in kmalloc"=0A=0AThis re=
verts commit 31fa6e2ae65feed0de10823c5d1eea21a93086c9.=0A=0ACommits from @u=
mn.edu addresses have been found to be submitted in "bad=0Afaith" to try to=
 test the kernel community's ability to review "known=0Amalicious" changes.=
  The result of these submissions can be found in a=0Apaper published at th=
e 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Open Source Inse=
curity: Stealthily Introducing=0AVulnerabilities via Hypocrite Commits" wri=
tten by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (University of=
 Minnesota).=0A=0ABecause of this, all submissions from this group must be =
reverted from=0Athe kernel tree and will need to be re-reviewed again to de=
termine if=0Athey actually are a valid fix.  Until that work is complete, r=
emove this=0Achange to ensure that no problems are being introduced into th=
e=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.c=
om>=0A---=0A drivers/video/fbdev/omap2/omapfb/dss/omapdss-boot-init.c | 2 -=
-=0A 1 file changed, 2 deletions(-)=0A=0Adiff --git a/drivers/video/fbdev/o=
map2/omapfb/dss/omapdss-boot-init.c b/drivers/video/fbdev/omap2/omapfb/dss/=
omapdss-boot-init.c=0Aindex 0ae0cab252d3..05d87dcbdd8b 100644=0A--- a/drive=
rs/video/fbdev/omap2/omapfb/dss/omapdss-boot-init.c=0A+++ b/drivers/video/f=
bdev/omap2/omapfb/dss/omapdss-boot-init.c=0A@@ -100,8 +100,6 @@ static void=
 __init omapdss_omapify_node(struct device_node *node)=0A =0A 	new_len =3D =
prop->length + strlen(prefix) * num_strs;=0A 	new_compat =3D kmalloc(new_le=
n, GFP_KERNEL);=0A-	if (!new_compat)=0A-		return;=0A =0A 	omapdss_prefix_st=
rcpy(new_compat, new_len, prop->value, prop->length);=0A =0A-- =0A2.30.2=0A=
=0A=0AFrom 2194ad4120d5396be072cd055256a548443402ae Mon Sep 17 00:00:00 200=
1=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr =
2021 20:23:48 +0100=0ASubject: [PATCH 024/151] Revert "media: video-mux: fi=
x null pointer=0A dereferences"=0A=0AThis reverts commit aeb0d0f581e2079868=
e64a2e5ee346d340376eae.=0A=0ACommits from @umn.edu addresses have been foun=
d to be submitted in "bad=0Afaith" to try to test the kernel community's ab=
ility to review "known=0Amalicious" changes.  The result of these submissio=
ns can be found in a=0Apaper published at the 42nd IEEE Symposium on Securi=
ty and Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=
=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu (University=
=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of =
this, all submissions from this group must be reverted from=0Athe kernel tr=
ee and will need to be re-reviewed again to determine if=0Athey actually ar=
e a valid fix.  Until that work is complete, remove this=0Achange to ensure=
 that no problems are being introduced into the=0Acodebase.=0A=0ASigned-off=
-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/media/pl=
atform/video-mux.c | 5 -----=0A 1 file changed, 5 deletions(-)=0A=0Adiff --=
git a/drivers/media/platform/video-mux.c b/drivers/media/platform/video-mux=
=2Ec=0Aindex ddd0e338f9e4..32378e10cb77 100644=0A--- a/drivers/media/platfo=
rm/video-mux.c=0A+++ b/drivers/media/platform/video-mux.c=0A@@ -411,14 +411=
,9 @@ static int video_mux_probe(struct platform_device *pdev)=0A 	vmux->ac=
tive =3D -1;=0A 	vmux->pads =3D devm_kcalloc(dev, num_pads, sizeof(*vmux->p=
ads),=0A 				  GFP_KERNEL);=0A-	if (!vmux->pads)=0A-		return -ENOMEM;=0A-=
=0A 	vmux->format_mbus =3D devm_kcalloc(dev, num_pads,=0A 					 sizeof(*vmu=
x->format_mbus),=0A 					 GFP_KERNEL);=0A-	if (!vmux->format_mbus)=0A-		ret=
urn -ENOMEM;=0A =0A 	for (i =3D 0; i < num_pads; i++) {=0A 		vmux->pads[i].=
flags =3D (i < num_pads - 1) ? MEDIA_PAD_FL_SINK=0A-- =0A2.30.2=0A=0A=0AFro=
m c9f67669baf7a4dab802e7c3aecca20e79de8435 Mon Sep 17 00:00:00 2001=0AFrom:=
 Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:2=
3:48 +0100=0ASubject: [PATCH 025/151] Revert "thunderbolt: property: Fix a =
missing check of=0A kzalloc"=0A=0AThis reverts commit 6183d5a51866f3acdeeb6=
6b75e87d44025b01a55.=0A=0ACommits from @umn.edu addresses have been found t=
o be submitted in "bad=0Afaith" to try to test the kernel community's abili=
ty to review "known=0Amalicious" changes.  The result of these submissions =
can be found in a=0Apaper published at the 42nd IEEE Symposium on Security =
and Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AV=
ulnerabilities via Hypocrite Commits" written by Qiushi Wu (University=0Aof=
 Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this,=
 all submissions from this group must be reverted from=0Athe kernel tree an=
d will need to be re-reviewed again to determine if=0Athey actually are a v=
alid fix.  Until that work is complete, remove this=0Achange to ensure that=
 no problems are being introduced into the=0Acodebase.=0A=0ASigned-off-by: =
Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/thunderbolt/p=
roperty.c | 7 +------=0A 1 file changed, 1 insertion(+), 6 deletions(-)=0A=
=0Adiff --git a/drivers/thunderbolt/property.c b/drivers/thunderbolt/proper=
ty.c=0Aindex d5b0cdb8f0b1..841314deb446 100644=0A--- a/drivers/thunderbolt/=
property.c=0A+++ b/drivers/thunderbolt/property.c=0A@@ -587,12 +587,7 @@ in=
t tb_property_add_text(struct tb_property_dir *parent, const char *key,=0A =
		return -ENOMEM;=0A =0A 	property->length =3D size / 4;=0A-	property->valu=
e.text =3D kzalloc(size, GFP_KERNEL);=0A-	if (!property->value.text) {=0A-	=
	kfree(property);=0A-		return -ENOMEM;=0A-	}=0A-=0A+	property->value.data =
=3D kzalloc(size, GFP_KERNEL);=0A 	strcpy(property->value.text, text);=0A =
=0A 	list_add_tail(&property->list, &parent->properties);=0A-- =0A2.30.2=0A=
=0A=0AFrom 17a011bcf36c3dec96c7a13a1ccee7dde729b5a4 Mon Sep 17 00:00:00 200=
1=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr =
2021 20:23:49 +0100=0ASubject: [PATCH 026/151] Revert "char: hpet: fix a mi=
ssing check of ioremap"=0A=0AThis reverts commit 13bd14a41ce3105d5b1f3cd8b4=
d1e249d17b6d9b.=0A=0ACommits from @umn.edu addresses have been found to be =
submitted in "bad=0Afaith" to try to test the kernel community's ability to=
 review "known=0Amalicious" changes.  The result of these submissions can b=
e found in a=0Apaper published at the 42nd IEEE Symposium on Security and P=
rivacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVulner=
abilities via Hypocrite Commits" written by Qiushi Wu (University=0Aof Minn=
esota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, all =
submissions from this group must be reverted from=0Athe kernel tree and wil=
l need to be re-reviewed again to determine if=0Athey actually are a valid =
fix.  Until that work is complete, remove this=0Achange to ensure that no p=
roblems are being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip=
 Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/char/hpet.c | 2 --=
=0A 1 file changed, 2 deletions(-)=0A=0Adiff --git a/drivers/char/hpet.c b/=
drivers/char/hpet.c=0Aindex f69609b47fef..3e31740444f1 100644=0A--- a/drive=
rs/char/hpet.c=0A+++ b/drivers/char/hpet.c=0A@@ -969,8 +969,6 @@ static acp=
i_status hpet_resources(struct acpi_resource *res, void *data)=0A 	if (ACPI=
_SUCCESS(status)) {=0A 		hdp->hd_phys_address =3D addr.address.minimum;=0A =
		hdp->hd_address =3D ioremap(addr.address.minimum, addr.address.address_le=
ngth);=0A-		if (!hdp->hd_address)=0A-			return AE_ERROR;=0A =0A 		if (hpet_=
is_known(hdp)) {=0A 			iounmap(hdp->hd_address);=0A-- =0A2.30.2=0A=0A=0AFro=
m 9626c2d0b50207bfcf036a959cd4f68532869dd0 Mon Sep 17 00:00:00 2001=0AFrom:=
 Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:2=
3:49 +0100=0ASubject: [PATCH 027/151] Revert "thunderbolt: Fix a missing ch=
eck of kmemdup"=0A=0AThis reverts commit e4dfdd5804cce1255f99c5dd033526a181=
35a616.=0A=0ACommits from @umn.edu addresses have been found to be submitte=
d in "bad=0Afaith" to try to test the kernel community's ability to review =
"known=0Amalicious" changes.  The result of these submissions can be found =
in a=0Apaper published at the 42nd IEEE Symposium on Security and Privacy=
=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVulnerabilit=
ies via Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnesota)=
 and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, all submis=
sions from this group must be reverted from=0Athe kernel tree and will need=
 to be re-reviewed again to determine if=0Athey actually are a valid fix.  =
Until that work is complete, remove this=0Achange to ensure that no problem=
s are being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukhe=
rjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/thunderbolt/property.c |=
 4 ----=0A 1 file changed, 4 deletions(-)=0A=0Adiff --git a/drivers/thunder=
bolt/property.c b/drivers/thunderbolt/property.c=0Aindex 841314deb446..ee76=
449524a3 100644=0A--- a/drivers/thunderbolt/property.c=0A+++ b/drivers/thun=
derbolt/property.c=0A@@ -176,10 +176,6 @@ static struct tb_property_dir *__=
tb_property_parse_dir(const u32 *block,=0A 	} else {=0A 		dir->uuid =3D kme=
mdup(&block[dir_offset], sizeof(*dir->uuid),=0A 				    GFP_KERNEL);=0A-		i=
f (!dir->uuid) {=0A-			tb_property_free_dir(dir);=0A-			return NULL;=0A-		}=
=0A 		content_offset =3D dir_offset + 4;=0A 		content_len =3D dir_len - 4; =
/* Length includes UUID */=0A 	}=0A-- =0A2.30.2=0A=0A=0AFrom 0eb4b6aeb8f921=
9b34615ad89e0f4f77da384136 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee=
 <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:23:50 +0100=0ASub=
ject: [PATCH 028/151] Revert "spi : spi-topcliff-pch: Fix to handle empty=
=0A DMA buffers"=0A=0AThis reverts commit f37d8e67f39e6d3eaf4cc5471e8a3d212=
09843c6.=0A=0ACommits from @umn.edu addresses have been found to be submitt=
ed in "bad=0Afaith" to try to test the kernel community's ability to review=
 "known=0Amalicious" changes.  The result of these submissions can be found=
 in a=0Apaper published at the 42nd IEEE Symposium on Security and Privacy=
=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVulnerabilit=
ies via Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnesota)=
 and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, all submis=
sions from this group must be reverted from=0Athe kernel tree and will need=
 to be re-reviewed again to determine if=0Athey actually are a valid fix.  =
Until that work is complete, remove this=0Achange to ensure that no problem=
s are being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukhe=
rjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/spi/spi-topcliff-pch.c |=
 15 ++-------------=0A 1 file changed, 2 insertions(+), 13 deletions(-)=0A=
=0Adiff --git a/drivers/spi/spi-topcliff-pch.c b/drivers/spi/spi-topcliff-p=
ch.c=0Aindex f88cbb94ce12..a900079fc78f 100644=0A--- a/drivers/spi/spi-topc=
liff-pch.c=0A+++ b/drivers/spi/spi-topcliff-pch.c=0A@@ -1291,27 +1291,18 @@=
 static void pch_free_dma_buf(struct pch_spi_board_data *board_dat,=0A 				=
  dma->rx_buf_virt, dma->rx_buf_dma);=0A }=0A =0A-static int pch_alloc_dma_=
buf(struct pch_spi_board_data *board_dat,=0A+static void pch_alloc_dma_buf(=
struct pch_spi_board_data *board_dat,=0A 			      struct pch_spi_data *data=
)=0A {=0A 	struct pch_spi_dma_ctrl *dma;=0A-	int ret;=0A =0A 	dma =3D &data=
->dma;=0A-	ret =3D 0;=0A 	/* Get Consistent memory for Tx DMA */=0A 	dma->t=
x_buf_virt =3D dma_alloc_coherent(&board_dat->pdev->dev,=0A 				PCH_BUF_SIZ=
E, &dma->tx_buf_dma, GFP_KERNEL);=0A-	if (!dma->tx_buf_virt)=0A-		ret =3D -=
ENOMEM;=0A-=0A 	/* Get Consistent memory for Rx DMA */=0A 	dma->rx_buf_virt=
 =3D dma_alloc_coherent(&board_dat->pdev->dev,=0A 				PCH_BUF_SIZE, &dma->r=
x_buf_dma, GFP_KERNEL);=0A-	if (!dma->rx_buf_virt)=0A-		ret =3D -ENOMEM;=0A=
-=0A-	return ret;=0A }=0A =0A static int pch_spi_pd_probe(struct platform_d=
evice *plat_dev)=0A@@ -1388,9 +1379,7 @@ static int pch_spi_pd_probe(struct=
 platform_device *plat_dev)=0A =0A 	if (use_dma) {=0A 		dev_info(&plat_dev-=
>dev, "Use DMA for data transfers\n");=0A-		ret =3D pch_alloc_dma_buf(board=
_dat, data);=0A-		if (ret)=0A-			goto err_spi_register_master;=0A+		pch_all=
oc_dma_buf(board_dat, data);=0A 	}=0A =0A 	ret =3D spi_register_master(mast=
er);=0A-- =0A2.30.2=0A=0A=0AFrom b918fa395f2d23b645aabc2f7fe1be4f6c0e4413 M=
on Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com=
>=0ADate: Wed, 21 Apr 2021 20:23:50 +0100=0ASubject: [PATCH 029/151] Revert=
 "scsi: ufs: fix a missing check of=0A devm_reset_control_get"=0A=0AThis re=
verts commit 63a06181d7ce169d09843645c50fea1901bc9f0a.=0A=0ACommits from @u=
mn.edu addresses have been found to be submitted in "bad=0Afaith" to try to=
 test the kernel community's ability to review "known=0Amalicious" changes.=
  The result of these submissions can be found in a=0Apaper published at th=
e 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Open Source Inse=
curity: Stealthily Introducing=0AVulnerabilities via Hypocrite Commits" wri=
tten by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (University of=
 Minnesota).=0A=0ABecause of this, all submissions from this group must be =
reverted from=0Athe kernel tree and will need to be re-reviewed again to de=
termine if=0Athey actually are a valid fix.  Until that work is complete, r=
emove this=0Achange to ensure that no problems are being introduced into th=
e=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.c=
om>=0A---=0A drivers/scsi/ufs/ufs-hisi.c | 4 ----=0A 1 file changed, 4 dele=
tions(-)=0A=0Adiff --git a/drivers/scsi/ufs/ufs-hisi.c b/drivers/scsi/ufs/u=
fs-hisi.c=0Aindex 6bbb1679bb91..b3235b3568d2 100644=0A--- a/drivers/scsi/uf=
s/ufs-hisi.c=0A+++ b/drivers/scsi/ufs/ufs-hisi.c=0A@@ -482,10 +482,6 @@ sta=
tic int ufs_hisi_init_common(struct ufs_hba *hba)=0A 	ufshcd_set_variant(hb=
a, host);=0A =0A 	host->rst  =3D devm_reset_control_get(dev, "rst");=0A-	if=
 (IS_ERR(host->rst)) {=0A-		dev_err(dev, "%s: failed to get reset control\n=
", __func__);=0A-		return PTR_ERR(host->rst);=0A-	}=0A =0A 	ufs_hisi_set_pm=
_lvl(hba);=0A =0A-- =0A2.30.2=0A=0A=0AFrom 5021aa56101c319f6517289bd09f9d31=
83e8bcf3 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee=
@gmail.com>=0ADate: Wed, 21 Apr 2021 20:23:51 +0100=0ASubject: [PATCH 030/1=
51] Revert "netfilter: ip6t_srh: fix NULL pointer=0A dereferences"=0A=0AThi=
s reverts commit 6d65561f3d5ec933151939c543d006b79044e7a6.=0A=0ACommits fro=
m @umn.edu addresses have been found to be submitted in "bad=0Afaith" to tr=
y to test the kernel community's ability to review "known=0Amalicious" chan=
ges.  The result of these submissions can be found in a=0Apaper published a=
t the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Open Source =
Insecurity: Stealthily Introducing=0AVulnerabilities via Hypocrite Commits"=
 written by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (Universit=
y of Minnesota).=0A=0ABecause of this, all submissions from this group must=
 be reverted from=0Athe kernel tree and will need to be re-reviewed again t=
o determine if=0Athey actually are a valid fix.  Until that work is complet=
e, remove this=0Achange to ensure that no problems are being introduced int=
o the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gma=
il.com>=0A---=0A net/ipv6/netfilter/ip6t_srh.c | 6 ------=0A 1 file changed=
, 6 deletions(-)=0A=0Adiff --git a/net/ipv6/netfilter/ip6t_srh.c b/net/ipv6=
/netfilter/ip6t_srh.c=0Aindex db0fd64d8986..f172702257a7 100644=0A--- a/net=
/ipv6/netfilter/ip6t_srh.c=0A+++ b/net/ipv6/netfilter/ip6t_srh.c=0A@@ -206,=
8 +206,6 @@ static bool srh1_mt6(const struct sk_buff *skb, struct xt_actio=
n_param *par)=0A 		psidoff =3D srhoff + sizeof(struct ipv6_sr_hdr) +=0A 			=
  ((srh->segments_left + 1) * sizeof(struct in6_addr));=0A 		psid =3D skb_h=
eader_pointer(skb, psidoff, sizeof(_psid), &_psid);=0A-		if (!psid)=0A-			r=
eturn false;=0A 		if (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_PSID,=0A 				ipv6_m=
asked_addr_cmp(psid, &srhinfo->psid_msk,=0A 						     &srhinfo->psid_addr)=
))=0A@@ -221,8 +219,6 @@ static bool srh1_mt6(const struct sk_buff *skb, st=
ruct xt_action_param *par)=0A 		nsidoff =3D srhoff + sizeof(struct ipv6_sr_=
hdr) +=0A 			  ((srh->segments_left - 1) * sizeof(struct in6_addr));=0A 		n=
sid =3D skb_header_pointer(skb, nsidoff, sizeof(_nsid), &_nsid);=0A-		if (!=
nsid)=0A-			return false;=0A 		if (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_NSID,=
=0A 				ipv6_masked_addr_cmp(nsid, &srhinfo->nsid_msk,=0A 						     &srhin=
fo->nsid_addr)))=0A@@ -233,8 +229,6 @@ static bool srh1_mt6(const struct sk=
_buff *skb, struct xt_action_param *par)=0A 	if (srhinfo->mt_flags & IP6T_S=
RH_LSID) {=0A 		lsidoff =3D srhoff + sizeof(struct ipv6_sr_hdr);=0A 		lsid =
=3D skb_header_pointer(skb, lsidoff, sizeof(_lsid), &_lsid);=0A-		if (!lsid=
)=0A-			return false;=0A 		if (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_LSID,=0A 	=
			ipv6_masked_addr_cmp(lsid, &srhinfo->lsid_msk,=0A 						     &srhinfo->l=
sid_addr)))=0A-- =0A2.30.2=0A=0A=0AFrom 8bf60634c18a26ea0867195c0aa7bae8351=
048d9 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gm=
ail.com>=0ADate: Wed, 21 Apr 2021 20:23:51 +0100=0ASubject: [PATCH 031/151]=
 Revert "net: openvswitch: fix a NULL pointer=0A dereference"=0A=0AThis rev=
erts commit 6f19893b644a9454d85e593b5e90914e7a72b7dd.=0A=0ACommits from @um=
n.edu addresses have been found to be submitted in "bad=0Afaith" to try to =
test the kernel community's ability to review "known=0Amalicious" changes. =
 The result of these submissions can be found in a=0Apaper published at the=
 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Open Source Insec=
urity: Stealthily Introducing=0AVulnerabilities via Hypocrite Commits" writ=
ten by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (University of =
Minnesota).=0A=0ABecause of this, all submissions from this group must be r=
everted from=0Athe kernel tree and will need to be re-reviewed again to det=
ermine if=0Athey actually are a valid fix.  Until that work is complete, re=
move this=0Achange to ensure that no problems are being introduced into the=
=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.co=
m>=0A---=0A net/openvswitch/datapath.c | 4 ----=0A 1 file changed, 4 deleti=
ons(-)=0A=0Adiff --git a/net/openvswitch/datapath.c b/net/openvswitch/datap=
ath.c=0Aindex 4f097bd3339e..f2371365cd71 100644=0A--- a/net/openvswitch/dat=
apath.c=0A+++ b/net/openvswitch/datapath.c=0A@@ -438,10 +438,6 @@ static in=
t queue_userspace_packet(struct datapath *dp, struct sk_buff *skb,=0A =0A 	=
upcall =3D genlmsg_put(user_skb, 0, 0, &dp_packet_genl_family,=0A 			     0=
, upcall_info->cmd);=0A-	if (!upcall) {=0A-		err =3D -EINVAL;=0A-		goto out=
;=0A-	}=0A 	upcall->dp_ifindex =3D dp_ifindex;=0A =0A 	err =3D ovs_nla_put_=
key(key, key, OVS_PACKET_ATTR_KEY, false, user_skb);=0A-- =0A2.30.2=0A=0A=
=0AFrom 9b5487f799b1f9e81c23240bd57d512d6aa2292b Mon Sep 17 00:00:00 2001=
=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2=
021 20:23:51 +0100=0ASubject: [PATCH 032/151] Revert "net: tipc: fix a miss=
ing check of=0A nla_nest_start"=0A=0AThis reverts commit 4589e28db46ee4961e=
dfd794c5bb43887d38c8e5.=0A=0ACommits from @umn.edu addresses have been foun=
d to be submitted in "bad=0Afaith" to try to test the kernel community's ab=
ility to review "known=0Amalicious" changes.  The result of these submissio=
ns can be found in a=0Apaper published at the 42nd IEEE Symposium on Securi=
ty and Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=
=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu (University=
=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of =
this, all submissions from this group must be reverted from=0Athe kernel tr=
ee and will need to be re-reviewed again to determine if=0Athey actually ar=
e a valid fix.  Until that work is complete, remove this=0Achange to ensure=
 that no problems are being introduced into the=0Acodebase.=0A=0ASigned-off=
-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A net/tipc/group.c=
 | 3 ---=0A 1 file changed, 3 deletions(-)=0A=0Adiff --git a/net/tipc/group=
=2Ec b/net/tipc/group.c=0Aindex f53871baa42e..02beaefbbaa7 100644=0A--- a/n=
et/tipc/group.c=0A+++ b/net/tipc/group.c=0A@@ -926,9 +926,6 @@ int tipc_gro=
up_fill_sock_diag(struct tipc_group *grp, struct sk_buff *skb)=0A {=0A 	str=
uct nlattr *group =3D nla_nest_start_noflag(skb, TIPC_NLA_SOCK_GROUP);=0A =
=0A-	if (!group)=0A-		return -EMSGSIZE;=0A-=0A 	if (nla_put_u32(skb, TIPC_N=
LA_SOCK_GROUP_ID,=0A 			grp->type) ||=0A 	    nla_put_u32(skb, TIPC_NLA_SOC=
K_GROUP_INSTANCE,=0A-- =0A2.30.2=0A=0A=0AFrom 11f13dab02413f8b99c52daee4e44=
579e3f00e4f Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukher=
jee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:23:52 +0100=0ASubject: [PATCH 03=
3/151] Revert "net: strparser: fix a missing check for=0A create_singlethre=
ad_workqueue"=0A=0AThis reverts commit 228cd2dba27cee9956c1af97e6445be05688=
1e41.=0A=0ACommits from @umn.edu addresses have been found to be submitted =
in "bad=0Afaith" to try to test the kernel community's ability to review "k=
nown=0Amalicious" changes.  The result of these submissions can be found in=
 a=0Apaper published at the 42nd IEEE Symposium on Security and Privacy=0Ae=
ntitled, "Open Source Insecurity: Stealthily Introducing=0AVulnerabilities =
via Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnesota) and=
 Kangjie Lu (University of Minnesota).=0A=0ABecause of this, all submission=
s from this group must be reverted from=0Athe kernel tree and will need to =
be re-reviewed again to determine if=0Athey actually are a valid fix.  Unti=
l that work is complete, remove this=0Achange to ensure that no problems ar=
e being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee=
 <sudipm.mukherjee@gmail.com>=0A---=0A net/strparser/strparser.c | 2 --=0A =
1 file changed, 2 deletions(-)=0A=0Adiff --git a/net/strparser/strparser.c =
b/net/strparser/strparser.c=0Aindex b3815c1e8f2e..efce4ddaa320 100644=0A---=
 a/net/strparser/strparser.c=0A+++ b/net/strparser/strparser.c=0A@@ -542,8 =
+542,6 @@ EXPORT_SYMBOL_GPL(strp_check_rcv);=0A static int __init strp_dev_=
init(void)=0A {=0A 	strp_wq =3D create_singlethread_workqueue("kstrp");=0A-=
	if (unlikely(!strp_wq))=0A-		return -ENOMEM;=0A =0A 	return 0;=0A }=0A-- =
=0A2.30.2=0A=0A=0AFrom 0edb19ea957dbbe3f8907514a42c9a404899de1b Mon Sep 17 =
00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: =
Wed, 21 Apr 2021 20:23:52 +0100=0ASubject: [PATCH 034/151] Revert "media: s=
i2165: fix a missing check of return=0A value"=0A=0AThis reverts commit 0ab=
34a08812a3334350dbaf69a018ee0ab3d2ddd.=0A=0ACommits from @umn.edu addresses=
 have been found to be submitted in "bad=0Afaith" to try to test the kernel=
 community's ability to review "known=0Amalicious" changes.  The result of =
these submissions can be found in a=0Apaper published at the 42nd IEEE Symp=
osium on Security and Privacy=0Aentitled, "Open Source Insecurity: Stealthi=
ly Introducing=0AVulnerabilities via Hypocrite Commits" written by Qiushi W=
u (University=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=
=0ABecause of this, all submissions from this group must be reverted from=
=0Athe kernel tree and will need to be re-reviewed again to determine if=0A=
they actually are a valid fix.  Until that work is complete, remove this=0A=
change to ensure that no problems are being introduced into the=0Acodebase.=
=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A =
drivers/media/dvb-frontends/si2165.c | 8 +++-----=0A 1 file changed, 3 inse=
rtions(+), 5 deletions(-)=0A=0Adiff --git a/drivers/media/dvb-frontends/si2=
165.c b/drivers/media/dvb-frontends/si2165.c=0Aindex 3fdaef1935ef..fe5f04a5=
aa01 100644=0A--- a/drivers/media/dvb-frontends/si2165.c=0A+++ b/drivers/me=
dia/dvb-frontends/si2165.c=0A@@ -266,20 +266,18 @@ static u32 si2165_get_fe=
_clk(struct si2165_state *state)=0A =0A static int si2165_wait_init_done(st=
ruct si2165_state *state)=0A {=0A-	int ret;=0A+	int ret =3D -EINVAL;=0A 	u8=
 val =3D 0;=0A 	int i;=0A =0A 	for (i =3D 0; i < 3; ++i) {=0A-		ret =3D si2=
165_readreg8(state, REG_INIT_DONE, &val);=0A-		if (ret < 0)=0A-			return re=
t;=0A+		si2165_readreg8(state, REG_INIT_DONE, &val);=0A 		if (val =3D=3D 0x=
01)=0A 			return 0;=0A 		usleep_range(1000, 50000);=0A 	}=0A 	dev_err(&stat=
e->client->dev, "init_done was not set\n");=0A-	return -EINVAL;=0A+	return =
ret;=0A }=0A =0A static int si2165_upload_firmware_block(struct si2165_stat=
e *state,=0A-- =0A2.30.2=0A=0A=0AFrom 001c4758f94dcf364bd15e430caf42b8d9b48=
0ad Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmai=
l.com>=0ADate: Wed, 21 Apr 2021 20:23:53 +0100=0ASubject: [PATCH 035/151] R=
evert "net: 8390: fix potential NULL pointer=0A dereferences"=0A=0AThis rev=
erts commit c7cbc3e937b885c9394bf9d0ca21ceb75c2ac262.=0A=0ACommits from @um=
n.edu addresses have been found to be submitted in "bad=0Afaith" to try to =
test the kernel community's ability to review "known=0Amalicious" changes. =
 The result of these submissions can be found in a=0Apaper published at the=
 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Open Source Insec=
urity: Stealthily Introducing=0AVulnerabilities via Hypocrite Commits" writ=
ten by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (University of =
Minnesota).=0A=0ABecause of this, all submissions from this group must be r=
everted from=0Athe kernel tree and will need to be re-reviewed again to det=
ermine if=0Athey actually are a valid fix.  Until that work is complete, re=
move this=0Achange to ensure that no problems are being introduced into the=
=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.co=
m>=0A---=0A drivers/net/ethernet/8390/pcnet_cs.c | 10 ----------=0A 1 file =
changed, 10 deletions(-)=0A=0Adiff --git a/drivers/net/ethernet/8390/pcnet_=
cs.c b/drivers/net/ethernet/8390/pcnet_cs.c=0Aindex 645efac6310d..61e43802b=
9a5 100644=0A--- a/drivers/net/ethernet/8390/pcnet_cs.c=0A+++ b/drivers/net=
/ethernet/8390/pcnet_cs.c=0A@@ -289,11 +289,6 @@ static struct hw_info *get=
_hwinfo(struct pcmcia_device *link)=0A =0A     virt =3D ioremap(link->resou=
rce[2]->start,=0A 	    resource_size(link->resource[2]));=0A-    if (unlike=
ly(!virt)) {=0A-	    pcmcia_release_window(link, link->resource[2]);=0A-	  =
  return NULL;=0A-    }=0A-=0A     for (i =3D 0; i < NR_INFO; i++) {=0A 	pc=
mcia_map_mem_page(link, link->resource[2],=0A 		hw_info[i].offset & ~(resou=
rce_size(link->resource[2])-1));=0A@@ -1428,11 +1423,6 @@ static int setup_=
shmem_window(struct pcmcia_device *link, int start_pg,=0A     /* Try scribb=
ling on the buffer */=0A     info->base =3D ioremap(link->resource[3]->star=
t,=0A 			resource_size(link->resource[3]));=0A-    if (unlikely(!info->base=
)) {=0A-	    ret =3D -ENOMEM;=0A-	    goto failed;=0A-    }=0A-=0A     for =
(i =3D 0; i < (TX_PAGES<<8); i +=3D 2)=0A 	__raw_writew((i>>1), info->base+=
offset+i);=0A     udelay(100);=0A-- =0A2.30.2=0A=0A=0AFrom ceb2116d896fa878=
6fe032723101814313ec172f Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <=
sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:23:53 +0100=0ASubje=
ct: [PATCH 036/151] Revert "ALSA: sb8: add a check for request_region"=0A=
=0AThis reverts commit dcd0feac9bab901d5739de51b3f69840851f8919.=0A=0ACommi=
ts from @umn.edu addresses have been found to be submitted in "bad=0Afaith"=
 to try to test the kernel community's ability to review "known=0Amalicious=
" changes.  The result of these submissions can be found in a=0Apaper publi=
shed at the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Open S=
ource Insecurity: Stealthily Introducing=0AVulnerabilities via Hypocrite Co=
mmits" written by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (Uni=
versity of Minnesota).=0A=0ABecause of this, all submissions from this grou=
p must be reverted from=0Athe kernel tree and will need to be re-reviewed a=
gain to determine if=0Athey actually are a valid fix.  Until that work is c=
omplete, remove this=0Achange to ensure that no problems are being introduc=
ed into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherj=
ee@gmail.com>=0A---=0A sound/isa/sb/sb8.c | 4 ----=0A 1 file changed, 4 del=
etions(-)=0A=0Adiff --git a/sound/isa/sb/sb8.c b/sound/isa/sb/sb8.c=0Aindex=
 d67eae3988bd..6f1fc8789676 100644=0A--- a/sound/isa/sb/sb8.c=0A+++ b/sound=
/isa/sb/sb8.c=0A@@ -96,10 +96,6 @@ static int snd_sb8_probe(struct device *=
pdev, unsigned int dev)=0A =0A 	/* block the 0x388 port to avoid PnP confli=
cts */=0A 	acard->fm_res =3D request_region(0x388, 4, "SoundBlaster FM");=
=0A-	if (!acard->fm_res) {=0A-		err =3D -EBUSY;=0A-		goto _err;=0A-	}=0A =
=0A 	if (port[dev] !=3D SNDRV_AUTO_PORT) {=0A 		if ((err =3D snd_sbdsp_crea=
te(card, port[dev], irq[dev],=0A-- =0A2.30.2=0A=0A=0AFrom 2e67109fd6e768176=
dd1e2f824d8900a19972a32 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <s=
udipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:23:54 +0100=0ASubjec=
t: [PATCH 037/151] Revert "net: fujitsu: fix a potential NULL pointer=0A de=
reference"=0A=0AThis reverts commit 9f4d6358e11bbc7b839f9419636188e4151fb6e=
4.=0A=0ACommits from @umn.edu addresses have been found to be submitted in =
"bad=0Afaith" to try to test the kernel community's ability to review "know=
n=0Amalicious" changes.  The result of these submissions can be found in a=
=0Apaper published at the 42nd IEEE Symposium on Security and Privacy=0Aent=
itled, "Open Source Insecurity: Stealthily Introducing=0AVulnerabilities vi=
a Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnesota) and K=
angjie Lu (University of Minnesota).=0A=0ABecause of this, all submissions =
=66rom this group must be reverted from=0Athe kernel tree and will need to =
be re-reviewed again to determine if=0Athey actually are a valid fix.  Unti=
l that work is complete, remove this=0Achange to ensure that no problems ar=
e being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee=
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/ethernet/fujitsu/fmvj18x=
_cs.c | 5 -----=0A 1 file changed, 5 deletions(-)=0A=0Adiff --git a/drivers=
/net/ethernet/fujitsu/fmvj18x_cs.c b/drivers/net/ethernet/fujitsu/fmvj18x_c=
s.c=0Aindex 1eca0fdb9933..a69cd19a55ae 100644=0A--- a/drivers/net/ethernet/=
fujitsu/fmvj18x_cs.c=0A+++ b/drivers/net/ethernet/fujitsu/fmvj18x_cs.c=0A@@=
 -547,11 +547,6 @@ static int fmvj18x_get_hwinfo(struct pcmcia_device *link=
, u_char *node_id)=0A 	return -1;=0A =0A     base =3D ioremap(link->resourc=
e[2]->start, resource_size(link->resource[2]));=0A-    if (!base) {=0A-	   =
 pcmcia_release_window(link, link->resource[2]);=0A-	    return -ENOMEM;=0A=
-    }=0A-=0A     pcmcia_map_mem_page(link, link->resource[2], 0);=0A =0A  =
   /*=0A-- =0A2.30.2=0A=0A=0AFrom 4cd69ff46d8ca5d45c0f559aeeab5940460e8784 =
Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.co=
m>=0ADate: Wed, 21 Apr 2021 20:23:54 +0100=0ASubject: [PATCH 038/151] Rever=
t "net: qlogic: fix a potential NULL pointer=0A dereference"=0A=0AThis reve=
rts commit eb32cfcdef2305dc0e44a65d42801315669bb27e.=0A=0ACommits from @umn=
=2Eedu addresses have been found to be submitted in "bad=0Afaith" to try to=
 test the kernel community's ability to review "known=0Amalicious" changes.=
  The result of these submissions can be found in a=0Apaper published at th=
e 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Open Source Inse=
curity: Stealthily Introducing=0AVulnerabilities via Hypocrite Commits" wri=
tten by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (University of=
 Minnesota).=0A=0ABecause of this, all submissions from this group must be =
reverted from=0Athe kernel tree and will need to be re-reviewed again to de=
termine if=0Athey actually are a valid fix.  Until that work is complete, r=
emove this=0Achange to ensure that no problems are being introduced into th=
e=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.c=
om>=0A---=0A drivers/net/ethernet/qlogic/qla3xxx.c | 6 ------=0A 1 file cha=
nged, 6 deletions(-)=0A=0Adiff --git a/drivers/net/ethernet/qlogic/qla3xxx.=
c b/drivers/net/ethernet/qlogic/qla3xxx.c=0Aindex 986f26578d34..6d9f6b27bc8=
e 100644=0A--- a/drivers/net/ethernet/qlogic/qla3xxx.c=0A+++ b/drivers/net/=
ethernet/qlogic/qla3xxx.c=0A@@ -3886,12 +3886,6 @@ static int ql3xxx_probe(=
struct pci_dev *pdev,=0A 	netif_stop_queue(ndev);=0A =0A 	qdev->workqueue =
=3D create_singlethread_workqueue(ndev->name);=0A-	if (!qdev->workqueue) {=
=0A-		unregister_netdev(ndev);=0A-		err =3D -ENOMEM;=0A-		goto err_out_ioun=
map;=0A-	}=0A-=0A 	INIT_DELAYED_WORK(&qdev->reset_work, ql_reset_work);=0A =
	INIT_DELAYED_WORK(&qdev->tx_timeout_work, ql_tx_timeout_work);=0A 	INIT_DE=
LAYED_WORK(&qdev->link_state_work, ql_link_state_machine_work);=0A-- =0A2.3=
0.2=0A=0A=0AFrom bd9e04dc806b3de679533df8a8d2d566ee40169a Mon Sep 17 00:00:=
00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 2=
1 Apr 2021 20:23:55 +0100=0ASubject: [PATCH 039/151] Revert "md: Fix failed=
 allocation of=0A md_register_thread"=0A=0AThis reverts commit e406f12dde1a=
8375d77ea02d91f313fb1a9c6aec.=0A=0ACommits from @umn.edu addresses have bee=
n found to be submitted in "bad=0Afaith" to try to test the kernel communit=
y's ability to review "known=0Amalicious" changes.  The result of these sub=
missions can be found in a=0Apaper published at the 42nd IEEE Symposium on =
Security and Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introd=
ucing=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu (Univer=
sity=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause=
 of this, all submissions from this group must be reverted from=0Athe kerne=
l tree and will need to be re-reviewed again to determine if=0Athey actuall=
y are a valid fix.  Until that work is complete, remove this=0Achange to en=
sure that no problems are being introduced into the=0Acodebase.=0A=0ASigned=
-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/md/r=
aid10.c | 2 --=0A drivers/md/raid5.c  | 2 --=0A 2 files changed, 4 deletion=
s(-)=0A=0Adiff --git a/drivers/md/raid10.c b/drivers/md/raid10.c=0Aindex a1=
95a85cc366..cb628e167188 100644=0A--- a/drivers/md/raid10.c=0A+++ b/drivers=
/md/raid10.c=0A@@ -3923,8 +3923,6 @@ static int raid10_run(struct mddev *md=
dev)=0A 		set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);=0A 		mddev->sync_=
thread =3D md_register_thread(md_do_sync, mddev,=0A 							"reshape");=0A-	=
	if (!mddev->sync_thread)=0A-			goto out_free_conf;=0A 	}=0A =0A 	return 0;=
=0Adiff --git a/drivers/md/raid5.c b/drivers/md/raid5.c=0Aindex 08a7f97750f=
7..7671ca88282d 100644=0A--- a/drivers/md/raid5.c=0A+++ b/drivers/md/raid5.=
c=0A@@ -7412,8 +7412,6 @@ static int raid5_run(struct mddev *mddev)=0A 		se=
t_bit(MD_RECOVERY_RUNNING, &mddev->recovery);=0A 		mddev->sync_thread =3D m=
d_register_thread(md_do_sync, mddev,=0A 							"reshape");=0A-		if (!mddev-=
>sync_thread)=0A-			goto abort;=0A 	}=0A =0A 	/* Ok, everything is just fin=
e now */=0A-- =0A2.30.2=0A=0A=0AFrom 616c16937b5faecece2c9843df1d1b7d372a5e=
3d Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail=
=2Ecom>=0ADate: Wed, 21 Apr 2021 20:23:55 +0100=0ASubject: [PATCH 040/151] =
Revert "usb: u132-hcd: fix potential NULL pointer=0A dereference"=0A=0AThis=
 reverts commit 3de3dbe7c13210171ba8411e36b409a2c29c7415.=0A=0ACommits from=
 @umn.edu addresses have been found to be submitted in "bad=0Afaith" to try=
 to test the kernel community's ability to review "known=0Amalicious" chang=
es.  The result of these submissions can be found in a=0Apaper published at=
 the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Open Source I=
nsecurity: Stealthily Introducing=0AVulnerabilities via Hypocrite Commits" =
written by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (University=
 of Minnesota).=0A=0ABecause of this, all submissions from this group must =
be reverted from=0Athe kernel tree and will need to be re-reviewed again to=
 determine if=0Athey actually are a valid fix.  Until that work is complete=
, remove this=0Achange to ensure that no problems are being introduced into=
 the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmai=
l.com>=0A---=0A drivers/usb/host/u132-hcd.c | 2 --=0A 1 file changed, 2 del=
etions(-)=0A=0Adiff --git a/drivers/usb/host/u132-hcd.c b/drivers/usb/host/=
u132-hcd.c=0Aindex 4efee34f154f..42d25ffc50cd 100644=0A--- a/drivers/usb/ho=
st/u132-hcd.c=0A+++ b/drivers/usb/host/u132-hcd.c=0A@@ -3200,8 +3200,6 @@ s=
tatic int __init u132_hcd_init(void)=0A 		return -ENODEV;=0A 	printk(KERN_I=
NFO "driver %s\n", hcd_name);=0A 	workqueue =3D create_singlethread_workque=
ue("u132");=0A-	if (!workqueue)=0A-		return -ENOMEM;=0A 	retval =3D platfor=
m_driver_register(&u132_platform_driver);=0A 	if (retval)=0A 		destroy_work=
queue(workqueue);=0A-- =0A2.30.2=0A=0A=0AFrom 8269a233a44ef1dd77af31b7ac6b3=
fbe685e7581 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukher=
jee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:23:56 +0100=0ASubject: [PATCH 04=
1/151] Revert "net: rocker: fix a potential NULL pointer=0A dereference"=0A=
=0AThis reverts commit 5c149314d91876f743ee43efd75b6287ec55480e.=0A=0ACommi=
ts from @umn.edu addresses have been found to be submitted in "bad=0Afaith"=
 to try to test the kernel community's ability to review "known=0Amalicious=
" changes.  The result of these submissions can be found in a=0Apaper publi=
shed at the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Open S=
ource Insecurity: Stealthily Introducing=0AVulnerabilities via Hypocrite Co=
mmits" written by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (Uni=
versity of Minnesota).=0A=0ABecause of this, all submissions from this grou=
p must be reverted from=0Athe kernel tree and will need to be re-reviewed a=
gain to determine if=0Athey actually are a valid fix.  Until that work is c=
omplete, remove this=0Achange to ensure that no problems are being introduc=
ed into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherj=
ee@gmail.com>=0A---=0A drivers/net/ethernet/rocker/rocker_main.c | 5 -----=
=0A 1 file changed, 5 deletions(-)=0A=0Adiff --git a/drivers/net/ethernet/r=
ocker/rocker_main.c b/drivers/net/ethernet/rocker/rocker_main.c=0Aindex 5ab=
b3f9684ff..fc0c25723da5 100644=0A--- a/drivers/net/ethernet/rocker/rocker_m=
ain.c=0A+++ b/drivers/net/ethernet/rocker/rocker_main.c=0A@@ -2819,11 +2819=
,6 @@ static int rocker_switchdev_event(struct notifier_block *unused,=0A 	=
	memcpy(&switchdev_work->fdb_info, ptr,=0A 		       sizeof(switchdev_work->=
fdb_info));=0A 		switchdev_work->fdb_info.addr =3D kzalloc(ETH_ALEN, GFP_AT=
OMIC);=0A-		if (unlikely(!switchdev_work->fdb_info.addr)) {=0A-			kfree(swi=
tchdev_work);=0A-			return NOTIFY_BAD;=0A-		}=0A-=0A 		ether_addr_copy((u8 =
*)switchdev_work->fdb_info.addr,=0A 				fdb_info->addr);=0A 		/* Take a ref=
erence on the rocker device */=0A-- =0A2.30.2=0A=0A=0AFrom 9f1d588313c36739=
5c0baec5de6b8bed19ba067b Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <=
sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:23:56 +0100=0ASubje=
ct: [PATCH 042/151] Revert "net: lio_core: fix two NULL pointer=0A derefere=
nces"=0A=0AThis reverts commit 41af8b3a097c6fd17a4867efa25966927094f57c.=0A=
=0ACommits from @umn.edu addresses have been found to be submitted in "bad=
=0Afaith" to try to test the kernel community's ability to review "known=0A=
malicious" changes.  The result of these submissions can be found in a=0Apa=
per published at the 42nd IEEE Symposium on Security and Privacy=0Aentitled=
, "Open Source Insecurity: Stealthily Introducing=0AVulnerabilities via Hyp=
ocrite Commits" written by Qiushi Wu (University=0Aof Minnesota) and Kangji=
e Lu (University of Minnesota).=0A=0ABecause of this, all submissions from =
this group must be reverted from=0Athe kernel tree and will need to be re-r=
eviewed again to determine if=0Athey actually are a valid fix.  Until that =
work is complete, remove this=0Achange to ensure that no problems are being=
 introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudip=
m.mukherjee@gmail.com>=0A---=0A drivers/net/ethernet/cavium/liquidio/lio_co=
re.c | 10 ----------=0A 1 file changed, 10 deletions(-)=0A=0Adiff --git a/d=
rivers/net/ethernet/cavium/liquidio/lio_core.c b/drivers/net/ethernet/caviu=
m/liquidio/lio_core.c=0Aindex d7e805749a5b..880c5b319133 100644=0A--- a/dri=
vers/net/ethernet/cavium/liquidio/lio_core.c=0A+++ b/drivers/net/ethernet/c=
avium/liquidio/lio_core.c=0A@@ -1211,11 +1211,6 @@ int liquidio_change_mtu(=
struct net_device *netdev, int new_mtu)=0A =0A 	sc =3D (struct octeon_soft_=
command *)=0A 		octeon_alloc_soft_command(oct, OCTNET_CMD_SIZE, 16, 0);=0A-=
	if (!sc) {=0A-		netif_info(lio, rx_err, lio->netdev,=0A-			   "Failed to a=
llocate soft command\n");=0A-		return -ENOMEM;=0A-	}=0A =0A 	ncmd =3D (unio=
n octnet_cmd *)sc->virtdptr;=0A =0A@@ -1689,11 +1684,6 @@ int liquidio_set_=
fec(struct lio *lio, int on_off)=0A =0A 	sc =3D octeon_alloc_soft_command(o=
ct, OCTNET_CMD_SIZE,=0A 				       sizeof(struct oct_nic_seapi_resp), 0);=
=0A-	if (!sc) {=0A-		dev_err(&oct->pci_dev->dev,=0A-			"Failed to allocate =
soft command\n");=0A-		return -ENOMEM;=0A-	}=0A =0A 	ncmd =3D sc->virtdptr;=
=0A 	resp =3D sc->virtrptr;=0A-- =0A2.30.2=0A=0A=0AFrom 7a7dec6d5614c0adc08=
f137a91c9a47061e90ffa Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sud=
ipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:23:57 +0100=0ASubject:=
 [PATCH 043/151] Revert "net: atm: Reduce the severity of logging in=0A unl=
ink_clip_vcc"=0A=0AThis reverts commit 60f5c4aaae452ae9252128ef7f9ae222aa70=
c569.=0A=0ACommits from @umn.edu addresses have been found to be submitted =
in "bad=0Afaith" to try to test the kernel community's ability to review "k=
nown=0Amalicious" changes.  The result of these submissions can be found in=
 a=0Apaper published at the 42nd IEEE Symposium on Security and Privacy=0Ae=
ntitled, "Open Source Insecurity: Stealthily Introducing=0AVulnerabilities =
via Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnesota) and=
 Kangjie Lu (University of Minnesota).=0A=0ABecause of this, all submission=
s from this group must be reverted from=0Athe kernel tree and will need to =
be re-reviewed again to determine if=0Athey actually are a valid fix.  Unti=
l that work is complete, remove this=0Achange to ensure that no problems ar=
e being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee=
 <sudipm.mukherjee@gmail.com>=0A---=0A net/atm/clip.c | 6 +++---=0A 1 file =
changed, 3 insertions(+), 3 deletions(-)=0A=0Adiff --git a/net/atm/clip.c b=
/net/atm/clip.c=0Aindex 294cb9efe3d3..a7972da7235d 100644=0A--- a/net/atm/c=
lip.c=0A+++ b/net/atm/clip.c=0A@@ -89,7 +89,7 @@ static void unlink_clip_vc=
c(struct clip_vcc *clip_vcc)=0A 	struct clip_vcc **walk;=0A =0A 	if (!entry=
) {=0A-		pr_err("!clip_vcc->entry (clip_vcc %p)\n", clip_vcc);=0A+		pr_crit=
("!clip_vcc->entry (clip_vcc %p)\n", clip_vcc);=0A 		return;=0A 	}=0A 	neti=
f_tx_lock_bh(entry->neigh->dev);	/* block clip_start_xmit() */=0A@@ -109,10=
 +109,10 @@ static void unlink_clip_vcc(struct clip_vcc *clip_vcc)=0A 			er=
ror =3D neigh_update(entry->neigh, NULL, NUD_NONE,=0A 					     NEIGH_UPDAT=
E_F_ADMIN, 0);=0A 			if (error)=0A-				pr_err("neigh_update failed with %d\=
n", error);=0A+				pr_crit("neigh_update failed with %d\n", error);=0A 			g=
oto out;=0A 		}=0A-	pr_err("ATMARP: failed (entry %p, vcc 0x%p)\n", entry, =
clip_vcc);=0A+	pr_crit("ATMARP: failed (entry %p, vcc 0x%p)\n", entry, clip=
_vcc);=0A out:=0A 	netif_tx_unlock_bh(entry->neigh->dev);=0A }=0A-- =0A2.30=
=2E2=0A=0A=0AFrom 5acfb7bfcb6e9eeea45cfb6de533850afaa04e6f Mon Sep 17 00:00=
:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, =
21 Apr 2021 20:23:57 +0100=0ASubject: [PATCH 044/151] Revert "net: ixgbevf:=
 fix a missing check of=0A ixgbevf_write_msg_read_ack"=0A=0AThis reverts co=
mmit 20d437ee8f4899573e6ea76c06ef0206e98bccb6.=0A=0ACommits from @umn.edu a=
ddresses have been found to be submitted in "bad=0Afaith" to try to test th=
e kernel community's ability to review "known=0Amalicious" changes.  The re=
sult of these submissions can be found in a=0Apaper published at the 42nd I=
EEE Symposium on Security and Privacy=0Aentitled, "Open Source Insecurity: =
Stealthily Introducing=0AVulnerabilities via Hypocrite Commits" written by =
Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (University of Minneso=
ta).=0A=0ABecause of this, all submissions from this group must be reverted=
 from=0Athe kernel tree and will need to be re-reviewed again to determine =
if=0Athey actually are a valid fix.  Until that work is complete, remove th=
is=0Achange to ensure that no problems are being introduced into the=0Acode=
base.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A--=
-=0A drivers/net/ethernet/intel/ixgbevf/vf.c | 5 +++--=0A 1 file changed, 3=
 insertions(+), 2 deletions(-)=0A=0Adiff --git a/drivers/net/ethernet/intel=
/ixgbevf/vf.c b/drivers/net/ethernet/intel/ixgbevf/vf.c=0Aindex d5ce4963654=
8..cd3b81300cc7 100644=0A--- a/drivers/net/ethernet/intel/ixgbevf/vf.c=0A++=
+ b/drivers/net/ethernet/intel/ixgbevf/vf.c=0A@@ -508,8 +508,9 @@ static s3=
2 ixgbevf_update_mc_addr_list_vf(struct ixgbe_hw *hw,=0A 		vector_list[i++]=
 =3D ixgbevf_mta_vector(hw, ha->addr);=0A 	}=0A =0A-	return ixgbevf_write_m=
sg_read_ack(hw, msgbuf, msgbuf,=0A-			IXGBE_VFMAILBOX_SIZE);=0A+	ixgbevf_wr=
ite_msg_read_ack(hw, msgbuf, msgbuf, IXGBE_VFMAILBOX_SIZE);=0A+=0A+	return =
0;=0A }=0A =0A /**=0A-- =0A2.30.2=0A=0A=0AFrom cc587c65eac633a17a5b9748f14e=
f9ada767d4fb Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukhe=
rjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:23:57 +0100=0ASubject: [PATCH 0=
45/151] Revert "thunderbolt: property: Fix a NULL pointer=0A dereference"=
=0A=0AThis reverts commit 106204b56f60abf1bead7dceb88f2be3e34433da.=0A=0ACo=
mmits from @umn.edu addresses have been found to be submitted in "bad=0Afai=
th" to try to test the kernel community's ability to review "known=0Amalici=
ous" changes.  The result of these submissions can be found in a=0Apaper pu=
blished at the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Ope=
n Source Insecurity: Stealthily Introducing=0AVulnerabilities via Hypocrite=
 Commits" written by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (=
University of Minnesota).=0A=0ABecause of this, all submissions from this g=
roup must be reverted from=0Athe kernel tree and will need to be re-reviewe=
d again to determine if=0Athey actually are a valid fix.  Until that work i=
s complete, remove this=0Achange to ensure that no problems are being intro=
duced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukh=
erjee@gmail.com>=0A---=0A drivers/thunderbolt/property.c | 5 -----=0A 1 fil=
e changed, 5 deletions(-)=0A=0Adiff --git a/drivers/thunderbolt/property.c =
b/drivers/thunderbolt/property.c=0Aindex ee76449524a3..b2f0d6386cee 100644=
=0A--- a/drivers/thunderbolt/property.c=0A+++ b/drivers/thunderbolt/propert=
y.c=0A@@ -548,11 +548,6 @@ int tb_property_add_data(struct tb_property_dir =
*parent, const char *key,=0A =0A 	property->length =3D size / 4;=0A 	proper=
ty->value.data =3D kzalloc(size, GFP_KERNEL);=0A-	if (!property->value.data=
) {=0A-		kfree(property);=0A-		return -ENOMEM;=0A-	}=0A-=0A 	memcpy(propert=
y->value.data, buf, buflen);=0A =0A 	list_add_tail(&property->list, &parent=
->properties);=0A-- =0A2.30.2=0A=0A=0AFrom 8d3b211f027a729f42b545d430c7ff70=
39d9bf2c Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee=
@gmail.com>=0ADate: Wed, 21 Apr 2021 20:23:58 +0100=0ASubject: [PATCH 046/1=
51] Revert "tty: mxs-auart: fix a potential NULL pointer=0A dereference"=0A=
=0AThis reverts commit 6734330654dac550f12e932996b868c6d0dcb421.=0A=0ACommi=
ts from @umn.edu addresses have been found to be submitted in "bad=0Afaith"=
 to try to test the kernel community's ability to review "known=0Amalicious=
" changes.  The result of these submissions can be found in a=0Apaper publi=
shed at the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Open S=
ource Insecurity: Stealthily Introducing=0AVulnerabilities via Hypocrite Co=
mmits" written by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (Uni=
versity of Minnesota).=0A=0ABecause of this, all submissions from this grou=
p must be reverted from=0Athe kernel tree and will need to be re-reviewed a=
gain to determine if=0Athey actually are a valid fix.  Until that work is c=
omplete, remove this=0Achange to ensure that no problems are being introduc=
ed into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherj=
ee@gmail.com>=0A---=0A drivers/tty/serial/mxs-auart.c | 4 ----=0A 1 file ch=
anged, 4 deletions(-)=0A=0Adiff --git a/drivers/tty/serial/mxs-auart.c b/dr=
ivers/tty/serial/mxs-auart.c=0Aindex 5d483e996514..608fedb5224f 100644=0A--=
- a/drivers/tty/serial/mxs-auart.c=0A+++ b/drivers/tty/serial/mxs-auart.c=
=0A@@ -1684,10 +1684,6 @@ static int mxs_auart_probe(struct platform_device=
 *pdev)=0A =0A 	s->port.mapbase =3D r->start;=0A 	s->port.membase =3D iorem=
ap(r->start, resource_size(r));=0A-	if (!s->port.membase) {=0A-		ret =3D -E=
NOMEM;=0A-		goto out_disable_clks;=0A-	}=0A 	s->port.ops =3D &mxs_auart_ops=
;=0A 	s->port.iotype =3D UPIO_MEM;=0A 	s->port.fifosize =3D MXS_AUART_FIFO_=
SIZE;=0A-- =0A2.30.2=0A=0A=0AFrom c9da368cfec57f1887c11f3e3291492b4f71abe4 =
Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.co=
m>=0ADate: Wed, 21 Apr 2021 20:23:58 +0100=0ASubject: [PATCH 047/151] Rever=
t "serial: mvebu-uart: Fix to avoid a potential=0A NULL pointer dereference=
"=0A=0AThis reverts commit 32f47179833b63de72427131169809065db6745e.=0A=0AC=
ommits from @umn.edu addresses have been found to be submitted in "bad=0Afa=
ith" to try to test the kernel community's ability to review "known=0Amalic=
ious" changes.  The result of these submissions can be found in a=0Apaper p=
ublished at the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Op=
en Source Insecurity: Stealthily Introducing=0AVulnerabilities via Hypocrit=
e Commits" written by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu =
(University of Minnesota).=0A=0ABecause of this, all submissions from this =
group must be reverted from=0Athe kernel tree and will need to be re-review=
ed again to determine if=0Athey actually are a valid fix.  Until that work =
is complete, remove this=0Achange to ensure that no problems are being intr=
oduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.muk=
herjee@gmail.com>=0A---=0A drivers/tty/serial/mvebu-uart.c | 3 ---=0A 1 fil=
e changed, 3 deletions(-)=0A=0Adiff --git a/drivers/tty/serial/mvebu-uart.c=
 b/drivers/tty/serial/mvebu-uart.c=0Aindex e006f40ffdc0..5e6f661943eb 10064=
4=0A--- a/drivers/tty/serial/mvebu-uart.c=0A+++ b/drivers/tty/serial/mvebu-=
uart.c=0A@@ -818,9 +818,6 @@ static int mvebu_uart_probe(struct platform_de=
vice *pdev)=0A 		return -EINVAL;=0A 	}=0A =0A-	if (!match)=0A-		return -ENO=
DEV;=0A-=0A 	/* Assume that all UART ports have a DT alias or none has */=
=0A 	id =3D of_alias_get_id(pdev->dev.of_node, "serial");=0A 	if (!pdev->de=
v.of_node || id < 0)=0A-- =0A2.30.2=0A=0A=0AFrom 4d6cfe1c760906325813bc3a4d=
7fd710bd29e02e Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.muk=
herjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:23:59 +0100=0ASubject: [PATCH=
 048/151] Revert "ALSA: usx2y: Fix potential NULL pointer=0A dereference"=
=0A=0AThis reverts commit a2c6433ee5a35a8de6d563f6512a26f87835ea0f.=0A=0ACo=
mmits from @umn.edu addresses have been found to be submitted in "bad=0Afai=
th" to try to test the kernel community's ability to review "known=0Amalici=
ous" changes.  The result of these submissions can be found in a=0Apaper pu=
blished at the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Ope=
n Source Insecurity: Stealthily Introducing=0AVulnerabilities via Hypocrite=
 Commits" written by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (=
University of Minnesota).=0A=0ABecause of this, all submissions from this g=
roup must be reverted from=0Athe kernel tree and will need to be re-reviewe=
d again to determine if=0Athey actually are a valid fix.  Until that work i=
s complete, remove this=0Achange to ensure that no problems are being intro=
duced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukh=
erjee@gmail.com>=0A---=0A sound/usb/usx2y/usb_stream.c | 5 -----=0A 1 file =
changed, 5 deletions(-)=0A=0Adiff --git a/sound/usb/usx2y/usb_stream.c b/so=
und/usb/usx2y/usb_stream.c=0Aindex 091c071b270a..6bba17bf689a 100644=0A--- =
a/sound/usb/usx2y/usb_stream.c=0A+++ b/sound/usb/usx2y/usb_stream.c=0A@@ -9=
1,12 +91,7 @@ static int init_urbs(struct usb_stream_kernel *sk, unsigned u=
se_packsize,=0A =0A 	for (u =3D 0; u < USB_STREAM_NURBS; ++u) {=0A 		sk->in=
urb[u] =3D usb_alloc_urb(sk->n_o_ps, GFP_KERNEL);=0A-		if (!sk->inurb[u])=
=0A-			return -ENOMEM;=0A-=0A 		sk->outurb[u] =3D usb_alloc_urb(sk->n_o_ps,=
 GFP_KERNEL);=0A-		if (!sk->outurb[u])=0A-			return -ENOMEM;=0A 	}=0A =0A 	=
if (init_pipe_urbs(sk, use_packsize, sk->inurb, indata, dev, in_pipe) ||=0A=
-- =0A2.30.2=0A=0A=0AFrom ea30dbd50ac0d2c75fb303db3e74cb123c3db23a Mon Sep =
17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADat=
e: Wed, 21 Apr 2021 20:23:59 +0100=0ASubject: [PATCH 049/151] Revert "qlcni=
c: Avoid potential NULL pointer=0A dereference"=0A=0AThis reverts commit 5b=
f7295fe34a5251b1d241b9736af4697b590670.=0A=0ACommits from @umn.edu addresse=
s have been found to be submitted in "bad=0Afaith" to try to test the kerne=
l community's ability to review "known=0Amalicious" changes.  The result of=
 these submissions can be found in a=0Apaper published at the 42nd IEEE Sym=
posium on Security and Privacy=0Aentitled, "Open Source Insecurity: Stealth=
ily Introducing=0AVulnerabilities via Hypocrite Commits" written by Qiushi =
Wu (University=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=
=0ABecause of this, all submissions from this group must be reverted from=
=0Athe kernel tree and will need to be re-reviewed again to determine if=0A=
they actually are a valid fix.  Until that work is complete, remove this=0A=
change to ensure that no problems are being introduced into the=0Acodebase.=
=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A =
drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c | 2 --=0A 1 file change=
d, 2 deletions(-)=0A=0Adiff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcn=
ic_ethtool.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c=0Aindex =
a4cd6f2cfb86..3b0adda7cc9c 100644=0A--- a/drivers/net/ethernet/qlogic/qlcni=
c/qlcnic_ethtool.c=0A+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtoo=
l.c=0A@@ -1048,8 +1048,6 @@ int qlcnic_do_lb_test(struct qlcnic_adapter *ad=
apter, u8 mode)=0A =0A 	for (i =3D 0; i < QLCNIC_NUM_ILB_PKT; i++) {=0A 		s=
kb =3D netdev_alloc_skb(adapter->netdev, QLCNIC_ILB_PKT_SIZE);=0A-		if (!sk=
b)=0A-			break;=0A 		qlcnic_create_loopback_buff(skb->data, adapter->mac_ad=
dr);=0A 		skb_put(skb, QLCNIC_ILB_PKT_SIZE);=0A 		adapter->ahw->diag_cnt =
=3D 0;=0A-- =0A2.30.2=0A=0A=0AFrom 99ce2bd1dcbd93ec8cb0b7ddcb64247e7391f5cf=
 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.c=
om>=0ADate: Wed, 21 Apr 2021 20:24:00 +0100=0ASubject: [PATCH 050/151] Reve=
rt "tty: atmel_serial: fix a potential NULL=0A pointer dereference"=0A=0ATh=
is reverts commit c85be041065c0be8bc48eda4c45e0319caf1d0e5.=0A=0ACommits fr=
om @umn.edu addresses have been found to be submitted in "bad=0Afaith" to t=
ry to test the kernel community's ability to review "known=0Amalicious" cha=
nges.  The result of these submissions can be found in a=0Apaper published =
at the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Open Source=
 Insecurity: Stealthily Introducing=0AVulnerabilities via Hypocrite Commits=
" written by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (Universi=
ty of Minnesota).=0A=0ABecause of this, all submissions from this group mus=
t be reverted from=0Athe kernel tree and will need to be re-reviewed again =
to determine if=0Athey actually are a valid fix.  Until that work is comple=
te, remove this=0Achange to ensure that no problems are being introduced in=
to the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gm=
ail.com>=0A---=0A drivers/tty/serial/atmel_serial.c | 4 ----=0A 1 file chan=
ged, 4 deletions(-)=0A=0Adiff --git a/drivers/tty/serial/atmel_serial.c b/d=
rivers/tty/serial/atmel_serial.c=0Aindex 8a909d556185..a2be481ea62c 100644=
=0A--- a/drivers/tty/serial/atmel_serial.c=0A+++ b/drivers/tty/serial/atmel=
_serial.c=0A@@ -1254,10 +1254,6 @@ static int atmel_prepare_rx_dma(struct u=
art_port *port)=0A 					 sg_dma_len(&atmel_port->sg_rx)/2,=0A 					 DMA_DEV=
_TO_MEM,=0A 					 DMA_PREP_INTERRUPT);=0A-	if (!desc) {=0A-		dev_err(port->=
dev, "Preparing DMA cyclic failed\n");=0A-		goto chan_err;=0A-	}=0A 	desc->=
callback =3D atmel_complete_rx_dma;=0A 	desc->callback_param =3D port;=0A 	=
atmel_port->desc_rx =3D desc;=0A-- =0A2.30.2=0A=0A=0AFrom 4d2ce931b250ff18c=
7fd6ac1fee11db1664a72e9 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <s=
udipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:24:00 +0100=0ASubjec=
t: [PATCH 051/151] Revert "libertas: add checks for the return value of=0A =
sysfs_create_group"=0A=0AThis reverts commit 434256833d8eb988cb7f3b8a41699e=
2fe48d9332.=0A=0ACommits from @umn.edu addresses have been found to be subm=
itted in "bad=0Afaith" to try to test the kernel community's ability to rev=
iew "known=0Amalicious" changes.  The result of these submissions can be fo=
und in a=0Apaper published at the 42nd IEEE Symposium on Security and Priva=
cy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVulnerabil=
ities via Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnesot=
a) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, all subm=
issions from this group must be reverted from=0Athe kernel tree and will ne=
ed to be re-reviewed again to determine if=0Athey actually are a valid fix.=
  Until that work is complete, remove this=0Achange to ensure that no probl=
ems are being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Muk=
herjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/wireless/marvell/l=
ibertas/mesh.c | 5 -----=0A 1 file changed, 5 deletions(-)=0A=0Adiff --git =
a/drivers/net/wireless/marvell/libertas/mesh.c b/drivers/net/wireless/marve=
ll/libertas/mesh.c=0Aindex 2747c957d18c..a21c86d446fa 100644=0A--- a/driver=
s/net/wireless/marvell/libertas/mesh.c=0A+++ b/drivers/net/wireless/marvell=
/libertas/mesh.c=0A@@ -805,12 +805,7 @@ static void lbs_persist_config_init=
(struct net_device *dev)=0A {=0A 	int ret;=0A 	ret =3D sysfs_create_group(&=
(dev->dev.kobj), &boot_opts_group);=0A-	if (ret)=0A-		pr_err("failed to cre=
ate boot_opts_group.\n");=0A-=0A 	ret =3D sysfs_create_group(&(dev->dev.kob=
j), &mesh_ie_group);=0A-	if (ret)=0A-		pr_err("failed to create mesh_ie_gro=
up.\n");=0A }=0A =0A static void lbs_persist_config_remove(struct net_devic=
e *dev)=0A-- =0A2.30.2=0A=0A=0AFrom aec05aa7606aa681b1ebf891789894522d352de=
e Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.=
com>=0ADate: Wed, 21 Apr 2021 20:24:01 +0100=0ASubject: [PATCH 052/151] Rev=
ert "usb: sierra: fix a missing check of=0A device_create_file"=0A=0AThis r=
everts commit 1a137b47ce6bd4f4b14662d2f5ace913ea7ffbf8.=0A=0ACommits from @=
umn.edu addresses have been found to be submitted in "bad=0Afaith" to try t=
o test the kernel community's ability to review "known=0Amalicious" changes=
=2E  The result of these submissions can be found in a=0Apaper published at=
 the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Open Source I=
nsecurity: Stealthily Introducing=0AVulnerabilities via Hypocrite Commits" =
written by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (University=
 of Minnesota).=0A=0ABecause of this, all submissions from this group must =
be reverted from=0Athe kernel tree and will need to be re-reviewed again to=
 determine if=0Athey actually are a valid fix.  Until that work is complete=
, remove this=0Achange to ensure that no problems are being introduced into=
 the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmai=
l.com>=0A---=0A drivers/usb/storage/sierra_ms.c | 4 +++-=0A 1 file changed,=
 3 insertions(+), 1 deletion(-)=0A=0Adiff --git a/drivers/usb/storage/sierr=
a_ms.c b/drivers/usb/storage/sierra_ms.c=0Aindex e605cbc3d8bf..6ac60abd2e15=
 100644=0A--- a/drivers/usb/storage/sierra_ms.c=0A+++ b/drivers/usb/storage=
/sierra_ms.c=0A@@ -194,6 +194,8 @@ int sierra_ms_init(struct us_data *us)=
=0A 		kfree(swocInfo);=0A 	}=0A complete:=0A-	return device_create_file(&us=
->pusb_intf->dev, &dev_attr_truinst);=0A+	result =3D device_create_file(&us=
->pusb_intf->dev, &dev_attr_truinst);=0A+=0A+	return 0;=0A }=0A =0A-- =0A2.=
30.2=0A=0A=0AFrom 086a2632e0095db97981afe0f5d4ca6cc6c0c16a Mon Sep 17 00:00=
:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, =
21 Apr 2021 20:24:01 +0100=0ASubject: [PATCH 053/151] Revert "scsi: qla4xxx=
: fix a potential NULL pointer=0A dereference"=0A=0AThis reverts commit fba=
1bdd2a9a93f3e2181ec1936a3c2f6b37e7ed6.=0A=0ACommits from @umn.edu addresses=
 have been found to be submitted in "bad=0Afaith" to try to test the kernel=
 community's ability to review "known=0Amalicious" changes.  The result of =
these submissions can be found in a=0Apaper published at the 42nd IEEE Symp=
osium on Security and Privacy=0Aentitled, "Open Source Insecurity: Stealthi=
ly Introducing=0AVulnerabilities via Hypocrite Commits" written by Qiushi W=
u (University=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=
=0ABecause of this, all submissions from this group must be reverted from=
=0Athe kernel tree and will need to be re-reviewed again to determine if=0A=
they actually are a valid fix.  Until that work is complete, remove this=0A=
change to ensure that no problems are being introduced into the=0Acodebase.=
=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A =
drivers/scsi/qla4xxx/ql4_os.c | 2 --=0A 1 file changed, 2 deletions(-)=0A=
=0Adiff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os=
=2Ec=0Aindex df43cf6405a8..f07de9956040 100644=0A--- a/drivers/scsi/qla4xxx=
/ql4_os.c=0A+++ b/drivers/scsi/qla4xxx/ql4_os.c=0A@@ -3203,8 +3203,6 @@ sta=
tic int qla4xxx_conn_bind(struct iscsi_cls_session *cls_session,=0A 	if (is=
csi_conn_bind(cls_session, cls_conn, is_leading))=0A 		return -EINVAL;=0A 	=
ep =3D iscsi_lookup_endpoint(transport_fd);=0A-	if (!ep)=0A-		return -EINVA=
L;=0A 	conn =3D cls_conn->dd_data;=0A 	qla_conn =3D conn->dd_data;=0A 	qla_=
conn->qla_ep =3D ep->dd_data;=0A-- =0A2.30.2=0A=0A=0AFrom 42bf0f18f0d0c8295=
979ba8f28c4b3eff0ef4946 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <s=
udipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:24:02 +0100=0ASubjec=
t: [PATCH 054/151] Revert "libnvdimm/btt: Fix a kmemdup failure check"=0A=
=0AThis reverts commit 486fa92df4707b5df58d6508728bdb9321a59766.=0A=0ACommi=
ts from @umn.edu addresses have been found to be submitted in "bad=0Afaith"=
 to try to test the kernel community's ability to review "known=0Amalicious=
" changes.  The result of these submissions can be found in a=0Apaper publi=
shed at the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Open S=
ource Insecurity: Stealthily Introducing=0AVulnerabilities via Hypocrite Co=
mmits" written by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (Uni=
versity of Minnesota).=0A=0ABecause of this, all submissions from this grou=
p must be reverted from=0Athe kernel tree and will need to be re-reviewed a=
gain to determine if=0Athey actually are a valid fix.  Until that work is c=
omplete, remove this=0Achange to ensure that no problems are being introduc=
ed into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherj=
ee@gmail.com>=0A---=0A drivers/nvdimm/btt_devs.c | 18 +++++-------------=0A=
 1 file changed, 5 insertions(+), 13 deletions(-)=0A=0Adiff --git a/drivers=
/nvdimm/btt_devs.c b/drivers/nvdimm/btt_devs.c=0Aindex 3508a79110c7..3b3ced=
c9dc61 100644=0A--- a/drivers/nvdimm/btt_devs.c=0A+++ b/drivers/nvdimm/btt_=
devs.c=0A@@ -190,15 +190,14 @@ static struct device *__nd_btt_create(struct=
 nd_region *nd_region,=0A 		return NULL;=0A =0A 	nd_btt->id =3D ida_simple_=
get(&nd_region->btt_ida, 0, 0, GFP_KERNEL);=0A-	if (nd_btt->id < 0)=0A-		go=
to out_nd_btt;=0A+	if (nd_btt->id < 0) {=0A+		kfree(nd_btt);=0A+		return NU=
LL;=0A+	}=0A =0A 	nd_btt->lbasize =3D lbasize;=0A-	if (uuid) {=0A+	if (uuid=
)=0A 		uuid =3D kmemdup(uuid, 16, GFP_KERNEL);=0A-		if (!uuid)=0A-			goto o=
ut_put_id;=0A-	}=0A 	nd_btt->uuid =3D uuid;=0A 	dev =3D &nd_btt->dev;=0A 	d=
ev_set_name(dev, "btt%d.%d", nd_region->id, nd_btt->id);=0A@@ -213,13 +212,=
6 @@ static struct device *__nd_btt_create(struct nd_region *nd_region,=0A =
		return NULL;=0A 	}=0A 	return dev;=0A-=0A-out_put_id:=0A-	ida_simple_remo=
ve(&nd_region->btt_ida, nd_btt->id);=0A-=0A-out_nd_btt:=0A-	kfree(nd_btt);=
=0A-	return NULL;=0A }=0A =0A struct device *nd_btt_create(struct nd_region=
 *nd_region)=0A-- =0A2.30.2=0A=0A=0AFrom ec16eb179cd68203abc1450f3595f69162=
6b1b9c Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@g=
mail.com>=0ADate: Wed, 21 Apr 2021 20:24:02 +0100=0ASubject: [PATCH 055/151=
] Revert "x86/hpet: Prevent potential NULL pointer=0A dereference"=0A=0AThi=
s reverts commit 2e84f116afca3719c9d0a1a78b47b48f75fd5724.=0A=0ACommits fro=
m @umn.edu addresses have been found to be submitted in "bad=0Afaith" to tr=
y to test the kernel community's ability to review "known=0Amalicious" chan=
ges.  The result of these submissions can be found in a=0Apaper published a=
t the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Open Source =
Insecurity: Stealthily Introducing=0AVulnerabilities via Hypocrite Commits"=
 written by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (Universit=
y of Minnesota).=0A=0ABecause of this, all submissions from this group must=
 be reverted from=0Athe kernel tree and will need to be re-reviewed again t=
o determine if=0Athey actually are a valid fix.  Until that work is complet=
e, remove this=0Achange to ensure that no problems are being introduced int=
o the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gma=
il.com>=0A---=0A arch/x86/kernel/hpet.c | 2 --=0A 1 file changed, 2 deletio=
ns(-)=0A=0Adiff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c=0Ai=
ndex c6f791bc481e..16cc0933d992 100644=0A--- a/arch/x86/kernel/hpet.c=0A+++=
 b/arch/x86/kernel/hpet.c=0A@@ -820,8 +820,6 @@ int __init hpet_enable(void=
)=0A 		return 0;=0A =0A 	hpet_set_mapping();=0A-	if (!hpet_virt_address)=0A=
-		return 0;=0A =0A 	/* Validate that the config register is working */=0A =
	if (!hpet_cfg_working())=0A-- =0A2.30.2=0A=0A=0AFrom ae6dfed938cb840341a84=
6c011230411f2f4fe7d Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudip=
m.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:24:03 +0100=0ASubject: [=
PATCH 056/151] Revert "staging: rtl8188eu: Fix potential NULL=0A pointer de=
reference of kcalloc"=0A=0AThis reverts commit 7671ce0d92933762f469266daf43=
bd34d422d58c.=0A=0ACommits from @umn.edu addresses have been found to be su=
bmitted in "bad=0Afaith" to try to test the kernel community's ability to r=
eview "known=0Amalicious" changes.  The result of these submissions can be =
found in a=0Apaper published at the 42nd IEEE Symposium on Security and Pri=
vacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVulnerab=
ilities via Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnes=
ota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, all su=
bmissions from this group must be reverted from=0Athe kernel tree and will =
need to be re-reviewed again to determine if=0Athey actually are a valid fi=
x.  Until that work is complete, remove this=0Achange to ensure that no pro=
blems are being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip M=
ukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/staging/rtl8188eu/co=
re/rtw_xmit.c    |  9 ++-------=0A drivers/staging/rtl8188eu/include/rtw_xm=
it.h |  2 +-=0A drivers/staging/rtl8723bs/core/rtw_xmit.c    | 14 +++++++--=
-----=0A drivers/staging/rtl8723bs/include/rtw_xmit.h |  2 +-=0A 4 files ch=
anged, 11 insertions(+), 16 deletions(-)=0A=0Adiff --git a/drivers/staging/=
rtl8188eu/core/rtw_xmit.c b/drivers/staging/rtl8188eu/core/rtw_xmit.c=0Aind=
ex c37591657bac..08cbc56c00d3 100644=0A--- a/drivers/staging/rtl8188eu/core=
/rtw_xmit.c=0A+++ b/drivers/staging/rtl8188eu/core/rtw_xmit.c=0A@@ -174,9 +=
174,7 @@ s32 _rtw_init_xmit_priv(struct xmit_priv *pxmitpriv, struct adapte=
r *padapter)=0A =0A 	pxmitpriv->free_xmit_extbuf_cnt =3D num_xmit_extbuf;=
=0A =0A-	res =3D rtw_alloc_hwxmits(padapter);=0A-	if (res =3D=3D _FAIL)=0A-=
		goto exit;=0A+	rtw_alloc_hwxmits(padapter);=0A 	rtw_init_hwxmits(pxmitpri=
v->hwxmits, pxmitpriv->hwxmit_entry);=0A =0A 	for (i =3D 0; i < 4; i++)=0A@=
@ -1505,7 +1503,7 @@ s32 rtw_xmit_classifier(struct adapter *padapter, stru=
ct xmit_frame *pxmitframe)=0A 	return res;=0A }=0A =0A-s32 rtw_alloc_hwxmit=
s(struct adapter *padapter)=0A+void rtw_alloc_hwxmits(struct adapter *padap=
ter)=0A {=0A 	struct hw_xmit *hwxmits;=0A 	struct xmit_priv *pxmitpriv =3D =
&padapter->xmitpriv;=0A@@ -1514,8 +1512,6 @@ s32 rtw_alloc_hwxmits(struct a=
dapter *padapter)=0A =0A 	pxmitpriv->hwxmits =3D kcalloc(pxmitpriv->hwxmit_=
entry,=0A 				     sizeof(struct hw_xmit), GFP_KERNEL);=0A-	if (!pxmitpriv-=
>hwxmits)=0A-		return _FAIL;=0A =0A 	hwxmits =3D pxmitpriv->hwxmits;=0A =0A=
@@ -1523,7 +1519,6 @@ s32 rtw_alloc_hwxmits(struct adapter *padapter)=0A 	h=
wxmits[1] .sta_queue =3D &pxmitpriv->vi_pending;=0A 	hwxmits[2] .sta_queue =
=3D &pxmitpriv->be_pending;=0A 	hwxmits[3] .sta_queue =3D &pxmitpriv->bk_pe=
nding;=0A-	return _SUCCESS;=0A }=0A =0A void rtw_free_hwxmits(struct adapte=
r *padapter)=0Adiff --git a/drivers/staging/rtl8188eu/include/rtw_xmit.h b/=
drivers/staging/rtl8188eu/include/rtw_xmit.h=0Aindex ba7e15fbde72..788f59c7=
4ea1 100644=0A--- a/drivers/staging/rtl8188eu/include/rtw_xmit.h=0A+++ b/dr=
ivers/staging/rtl8188eu/include/rtw_xmit.h=0A@@ -336,7 +336,7 @@ s32 rtw_tx=
frames_sta_ac_pending(struct adapter *padapter,=0A void rtw_init_hwxmits(st=
ruct hw_xmit *phwxmit, int entry);=0A s32 _rtw_init_xmit_priv(struct xmit_p=
riv *pxmitpriv, struct adapter *padapter);=0A void _rtw_free_xmit_priv(stru=
ct xmit_priv *pxmitpriv);=0A-s32 rtw_alloc_hwxmits(struct adapter *padapter=
);=0A+void rtw_alloc_hwxmits(struct adapter *padapter);=0A void rtw_free_hw=
xmits(struct adapter *padapter);=0A s32 rtw_xmit(struct adapter *padapter, =
struct sk_buff **pkt);=0A =0Adiff --git a/drivers/staging/rtl8723bs/core/rt=
w_xmit.c b/drivers/staging/rtl8723bs/core/rtw_xmit.c=0Aindex b5dcb78fb4f4..=
8edbf9c12bde 100644=0A--- a/drivers/staging/rtl8723bs/core/rtw_xmit.c=0A+++=
 b/drivers/staging/rtl8723bs/core/rtw_xmit.c=0A@@ -260,9 +260,7 @@ s32 _rtw=
_init_xmit_priv(struct xmit_priv *pxmitpriv, struct adapter *padapter)=0A 	=
	}=0A 	}=0A =0A-	res =3D rtw_alloc_hwxmits(padapter);=0A-	if (res =3D=3D _F=
AIL)=0A-		goto exit;=0A+	rtw_alloc_hwxmits(padapter);=0A 	rtw_init_hwxmits(=
pxmitpriv->hwxmits, pxmitpriv->hwxmit_entry);=0A =0A 	for (i =3D 0; i < 4; =
i++) {=0A@@ -2144,7 +2142,7 @@ s32 rtw_xmit_classifier(struct adapter *pada=
pter, struct xmit_frame *pxmitframe)=0A 	return res;=0A }=0A =0A-s32 rtw_al=
loc_hwxmits(struct adapter *padapter)=0A+void rtw_alloc_hwxmits(struct adap=
ter *padapter)=0A {=0A 	struct hw_xmit *hwxmits;=0A 	struct xmit_priv *pxmi=
tpriv =3D &padapter->xmitpriv;=0A@@ -2155,8 +2153,10 @@ s32 rtw_alloc_hwxmi=
ts(struct adapter *padapter)=0A =0A 	pxmitpriv->hwxmits =3D rtw_zmalloc(siz=
eof(struct hw_xmit) * pxmitpriv->hwxmit_entry);=0A =0A-	if (!pxmitpriv->hwx=
mits)=0A-		return _FAIL;=0A+	if (pxmitpriv->hwxmits =3D=3D NULL) {=0A+		DBG=
_871X("alloc hwxmits fail!...\n");=0A+		return;=0A+	}=0A =0A 	hwxmits =3D p=
xmitpriv->hwxmits;=0A =0A@@ -2202,7 +2202,7 @@ s32 rtw_alloc_hwxmits(struct=
 adapter *padapter)=0A =0A 	}=0A =0A-	return _SUCCESS;=0A+=0A }=0A =0A void=
 rtw_free_hwxmits(struct adapter *padapter)=0Adiff --git a/drivers/staging/=
rtl8723bs/include/rtw_xmit.h b/drivers/staging/rtl8723bs/include/rtw_xmit.h=
=0Aindex ea1396005a13..5a3aa6827bb0 100644=0A--- a/drivers/staging/rtl8723b=
s/include/rtw_xmit.h=0A+++ b/drivers/staging/rtl8723bs/include/rtw_xmit.h=
=0A@@ -487,7 +487,7 @@ s32 _rtw_init_xmit_priv(struct xmit_priv *pxmitpriv,=
 struct adapter *padapter);=0A void _rtw_free_xmit_priv (struct xmit_priv *=
pxmitpriv);=0A =0A =0A-s32 rtw_alloc_hwxmits(struct adapter *padapter);=0A+=
void rtw_alloc_hwxmits(struct adapter *padapter);=0A void rtw_free_hwxmits(=
struct adapter *padapter);=0A =0A =0A-- =0A2.30.2=0A=0A=0AFrom 0f5e0a3d390d=
02f7e12d0c9333476c573a65907a Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherj=
ee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:24:03 +0100=0AS=
ubject: [PATCH 057/151] Revert "misc/ics932s401: Add a missing check to=0A =
i2c_smbus_read_word_data"=0A=0AThis reverts commit b05ae01fdb8966afff5b153e=
7a7ee24684745e2d.=0A=0ACommits from @umn.edu addresses have been found to b=
e submitted in "bad=0Afaith" to try to test the kernel community's ability =
to review "known=0Amalicious" changes.  The result of these submissions can=
 be found in a=0Apaper published at the 42nd IEEE Symposium on Security and=
 Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVuln=
erabilities via Hypocrite Commits" written by Qiushi Wu (University=0Aof Mi=
nnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, al=
l submissions from this group must be reverted from=0Athe kernel tree and w=
ill need to be re-reviewed again to determine if=0Athey actually are a vali=
d fix.  Until that work is complete, remove this=0Achange to ensure that no=
 problems are being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sud=
ip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/misc/ics932s401.=
c | 2 --=0A 1 file changed, 2 deletions(-)=0A=0Adiff --git a/drivers/misc/i=
cs932s401.c b/drivers/misc/ics932s401.c=0Aindex 2bdf560ee681..733e5c2b57ce =
100644=0A--- a/drivers/misc/ics932s401.c=0A+++ b/drivers/misc/ics932s401.c=
=0A@@ -133,8 +133,6 @@ static struct ics932s401_data *ics932s401_update_dev=
ice(struct device *dev)=0A 	 */=0A 	for (i =3D 0; i < NUM_MIRRORED_REGS; i+=
+) {=0A 		temp =3D i2c_smbus_read_word_data(client, regs_to_copy[i]);=0A-		=
if (temp < 0)=0A-			data->regs[regs_to_copy[i]] =3D 0;=0A 		data->regs[regs=
_to_copy[i]] =3D temp >> 8;=0A 	}=0A =0A-- =0A2.30.2=0A=0A=0AFrom 0a69d84d0=
6659f48a1e8fd0466449fe2091633f9 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukh=
erjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:24:04 +0100=
=0ASubject: [PATCH 058/151] Revert "media: usb: gspca: add a missed return-=
value=0A check for do_command"=0A=0AThis reverts commit 5ceaf5452c1b2a452da=
daf377f9f07af7bda9cc3.=0A=0ACommits from @umn.edu addresses have been found=
 to be submitted in "bad=0Afaith" to try to test the kernel community's abi=
lity to review "known=0Amalicious" changes.  The result of these submission=
s can be found in a=0Apaper published at the 42nd IEEE Symposium on Securit=
y and Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=
=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu (University=
=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of =
this, all submissions from this group must be reverted from=0Athe kernel tr=
ee and will need to be re-reviewed again to determine if=0Athey actually ar=
e a valid fix.  Until that work is complete, remove this=0Achange to ensure=
 that no problems are being introduced into the=0Acodebase.=0A=0ASigned-off=
-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/media/us=
b/gspca/cpia1.c | 8 ++------=0A 1 file changed, 2 insertions(+), 6 deletion=
s(-)=0A=0Adiff --git a/drivers/media/usb/gspca/cpia1.c b/drivers/media/usb/=
gspca/cpia1.c=0Aindex a4f7431486f3..5ee749e05267 100644=0A--- a/drivers/med=
ia/usb/gspca/cpia1.c=0A+++ b/drivers/media/usb/gspca/cpia1.c=0A@@ -537,14 +=
537,10 @@ static int do_command(struct gspca_dev *gspca_dev, u16 command,=
=0A 		}=0A 		if (sd->params.qx3.button) {=0A 			/* button pressed - unlock =
the latch */=0A-			ret =3D do_command(gspca_dev, CPIA_COMMAND_WriteMCPort,=
=0A+			do_command(gspca_dev, CPIA_COMMAND_WriteMCPort,=0A 				   3, 0xdf, 0=
xdf, 0);=0A-			if (ret)=0A-				return ret;=0A-			ret =3D do_command(gspca_d=
ev, CPIA_COMMAND_WriteMCPort,=0A+			do_command(gspca_dev, CPIA_COMMAND_Writ=
eMCPort,=0A 				   3, 0xff, 0xff, 0);=0A-			if (ret)=0A-				return ret;=0A =
		}=0A =0A 		/* test whether microscope is cradled */=0A-- =0A2.30.2=0A=0A=
=0AFrom 8bf3a0ff29770c9241d4cd669ad7024e8039ad3f Mon Sep 17 00:00:00 2001=
=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2=
021 20:24:04 +0100=0ASubject: [PATCH 059/151] Revert "ath6kl: return error =
code in=0A ath6kl_wmi_set_roam_lrssi_cmd()"=0A=0AThis reverts commit fc6a65=
21556c8250e356ddc6a3f2391aa62dc976.=0A=0ACommits from @umn.edu addresses ha=
ve been found to be submitted in "bad=0Afaith" to try to test the kernel co=
mmunity's ability to review "known=0Amalicious" changes.  The result of the=
se submissions can be found in a=0Apaper published at the 42nd IEEE Symposi=
um on Security and Privacy=0Aentitled, "Open Source Insecurity: Stealthily =
Introducing=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu (=
University=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=0AB=
ecause of this, all submissions from this group must be reverted from=0Athe=
 kernel tree and will need to be re-reviewed again to determine if=0Athey a=
ctually are a valid fix.  Until that work is complete, remove this=0Achange=
 to ensure that no problems are being introduced into the=0Acodebase.=0A=0A=
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A driver=
s/net/wireless/ath/ath6kl/wmi.c | 4 +++-=0A 1 file changed, 3 insertions(+)=
, 1 deletion(-)=0A=0Adiff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/d=
rivers/net/wireless/ath/ath6kl/wmi.c=0Aindex c610fe21c85c..d27b4088b874 100=
644=0A--- a/drivers/net/wireless/ath/ath6kl/wmi.c=0A+++ b/drivers/net/wirel=
ess/ath/ath6kl/wmi.c=0A@@ -776,8 +776,10 @@ int ath6kl_wmi_set_roam_lrssi_c=
md(struct wmi *wmi, u8 lrssi)=0A 	cmd->info.params.roam_rssi_floor =3D DEF_=
LRSSI_ROAM_FLOOR;=0A 	cmd->roam_ctrl =3D WMI_SET_LRSSI_SCAN_PARAMS;=0A =0A-=
	return ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_SET_ROAM_CTRL_CMDID,=0A+	ath6k=
l_wmi_cmd_send(wmi, 0, skb, WMI_SET_ROAM_CTRL_CMDID,=0A 			    NO_SYNC_WMIF=
LAG);=0A+=0A+	return 0;=0A }=0A =0A int ath6kl_wmi_force_roam_cmd(struct wm=
i *wmi, const u8 *bssid)=0A-- =0A2.30.2=0A=0A=0AFrom cd9b01948ac7731935bb3d=
9f0f4a40847978fde4 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm=
=2Emukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:24:05 +0100=0ASubject: =
[PATCH 060/151] Revert "Input: ad7879 - add check for read errors in=0A int=
errupt"=0A=0AThis reverts commit e85bb0beb6498c0dffe18a2f1f16d575bc175c32.=
=0A=0ACommits from @umn.edu addresses have been found to be submitted in "b=
ad=0Afaith" to try to test the kernel community's ability to review "known=
=0Amalicious" changes.  The result of these submissions can be found in a=
=0Apaper published at the 42nd IEEE Symposium on Security and Privacy=0Aent=
itled, "Open Source Insecurity: Stealthily Introducing=0AVulnerabilities vi=
a Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnesota) and K=
angjie Lu (University of Minnesota).=0A=0ABecause of this, all submissions =
=66rom this group must be reverted from=0Athe kernel tree and will need to =
be re-reviewed again to determine if=0Athey actually are a valid fix.  Unti=
l that work is complete, remove this=0Achange to ensure that no problems ar=
e being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee=
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/input/touchscreen/ad7879.c |=
 11 ++++-------=0A 1 file changed, 4 insertions(+), 7 deletions(-)=0A=0Adif=
f --git a/drivers/input/touchscreen/ad7879.c b/drivers/input/touchscreen/ad=
7879.c=0Aindex 556a2af46e18..297fac9c9f98 100644=0A--- a/drivers/input/touc=
hscreen/ad7879.c=0A+++ b/drivers/input/touchscreen/ad7879.c=0A@@ -245,14 +2=
45,11 @@ static void ad7879_timer(struct timer_list *t)=0A static irqreturn=
_t ad7879_irq(int irq, void *handle)=0A {=0A 	struct ad7879 *ts =3D handle;=
=0A-	int error;=0A =0A-	error =3D regmap_bulk_read(ts->regmap, AD7879_REG_X=
PLUS,=0A-				 ts->conversion_data, AD7879_NR_SENSE);=0A-	if (error)=0A-		de=
v_err_ratelimited(ts->dev, "failed to read %#02x: %d\n",=0A-				    AD7879_=
REG_XPLUS, error);=0A-	else if (!ad7879_report(ts))=0A+	regmap_bulk_read(ts=
->regmap, AD7879_REG_XPLUS,=0A+			 ts->conversion_data, AD7879_NR_SENSE);=
=0A+=0A+	if (!ad7879_report(ts))=0A 		mod_timer(&ts->timer, jiffies + TS_PE=
N_UP_TIMEOUT);=0A =0A 	return IRQ_HANDLED;=0A-- =0A2.30.2=0A=0A=0AFrom 8c3f=
59f38330689c1274995bd42546bcb285e4f1 Mon Sep 17 00:00:00 2001=0AFrom: Sudip=
 Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:24:05 +=
0100=0ASubject: [PATCH 061/151] Revert "serial: max310x: pass return value =
of=0A spi_register_driver"=0A=0AThis reverts commit 51f689cc11333944c7a457f=
25ec75fcb41e99410.=0A=0ACommits from @umn.edu addresses have been found to =
be submitted in "bad=0Afaith" to try to test the kernel community's ability=
 to review "known=0Amalicious" changes.  The result of these submissions ca=
n be found in a=0Apaper published at the 42nd IEEE Symposium on Security an=
d Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVul=
nerabilities via Hypocrite Commits" written by Qiushi Wu (University=0Aof M=
innesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, a=
ll submissions from this group must be reverted from=0Athe kernel tree and =
will need to be re-reviewed again to determine if=0Athey actually are a val=
id fix.  Until that work is complete, remove this=0Achange to ensure that n=
o problems are being introduced into the=0Acodebase.=0A=0ASigned-off-by: Su=
dip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/tty/serial/max3=
10x.c | 4 ++--=0A 1 file changed, 2 insertions(+), 2 deletions(-)=0A=0Adiff=
 --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c=0Ainde=
x 8434bd5a8ec7..f60b7b86d099 100644=0A--- a/drivers/tty/serial/max310x.c=0A=
+++ b/drivers/tty/serial/max310x.c=0A@@ -1527,10 +1527,10 @@ static int __i=
nit max310x_uart_init(void)=0A 		return ret;=0A =0A #ifdef CONFIG_SPI_MASTE=
R=0A-	ret =3D spi_register_driver(&max310x_spi_driver);=0A+	spi_register_dr=
iver(&max310x_spi_driver);=0A #endif=0A =0A-	return ret;=0A+	return 0;=0A }=
=0A module_init(max310x_uart_init);=0A =0A-- =0A2.30.2=0A=0A=0AFrom 02c1513=
6bab36f04c63f65615b74a6c48870a844 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mu=
kherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:24:06 +010=
0=0ASubject: [PATCH 062/151] Revert "ALSA: gus: add a check of the status o=
f=0A snd_ctl_add"=0A=0AThis reverts commit 0f25e000cb4398081748e54f62a90209=
8aa79ec1.=0A=0ACommits from @umn.edu addresses have been found to be submit=
ted in "bad=0Afaith" to try to test the kernel community's ability to revie=
w "known=0Amalicious" changes.  The result of these submissions can be foun=
d in a=0Apaper published at the 42nd IEEE Symposium on Security and Privacy=
=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVulnerabilit=
ies via Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnesota)=
 and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, all submis=
sions from this group must be reverted from=0Athe kernel tree and will need=
 to be re-reviewed again to determine if=0Athey actually are a valid fix.  =
Until that work is complete, remove this=0Achange to ensure that no problem=
s are being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukhe=
rjee <sudipm.mukherjee@gmail.com>=0A---=0A sound/isa/gus/gus_main.c | 13 ++=
-----------=0A 1 file changed, 2 insertions(+), 11 deletions(-)=0A=0Adiff -=
-git a/sound/isa/gus/gus_main.c b/sound/isa/gus/gus_main.c=0Aindex af6b4d89=
d695..39911a637e80 100644=0A--- a/sound/isa/gus/gus_main.c=0A+++ b/sound/is=
a/gus/gus_main.c=0A@@ -77,17 +77,8 @@ static const struct snd_kcontrol_new =
snd_gus_joystick_control =3D {=0A =0A static void snd_gus_init_control(stru=
ct snd_gus_card *gus)=0A {=0A-	int ret;=0A-=0A-	if (!gus->ace_flag) {=0A-		=
ret =3D=0A-			snd_ctl_add(gus->card,=0A-					snd_ctl_new1(&snd_gus_joystick=
_control,=0A-						gus));=0A-		if (ret)=0A-			snd_printk(KERN_ERR "gus: snd=
_ctl_add failed: %d\n",=0A-					ret);=0A-	}=0A+	if (!gus->ace_flag)=0A+		sn=
d_ctl_add(gus->card, snd_ctl_new1(&snd_gus_joystick_control, gus));=0A }=0A=
 =0A /*=0A-- =0A2.30.2=0A=0A=0AFrom 4426a45829b8247eba40a4861e84f6df1a1d67e=
d Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.=
com>=0ADate: Wed, 21 Apr 2021 20:24:06 +0100=0ASubject: [PATCH 063/151] Rev=
ert "Staging: rts5208: Fix error handling on=0A rtsx_send_cmd"=0A=0AThis re=
verts commit c8c2702409430a6a2fd928e857f15773aaafcc99.=0A=0ACommits from @u=
mn.edu addresses have been found to be submitted in "bad=0Afaith" to try to=
 test the kernel community's ability to review "known=0Amalicious" changes.=
  The result of these submissions can be found in a=0Apaper published at th=
e 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Open Source Inse=
curity: Stealthily Introducing=0AVulnerabilities via Hypocrite Commits" wri=
tten by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (University of=
 Minnesota).=0A=0ABecause of this, all submissions from this group must be =
reverted from=0Athe kernel tree and will need to be re-reviewed again to de=
termine if=0Athey actually are a valid fix.  Until that work is complete, r=
emove this=0Achange to ensure that no problems are being introduced into th=
e=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.c=
om>=0A---=0A drivers/staging/rts5208/sd.c | 7 +------=0A 1 file changed, 1 =
insertion(+), 6 deletions(-)=0A=0Adiff --git a/drivers/staging/rts5208/sd.c=
 b/drivers/staging/rts5208/sd.c=0Aindex 25c31496757e..63f5465a6eeb 100644=
=0A--- a/drivers/staging/rts5208/sd.c=0A+++ b/drivers/staging/rts5208/sd.c=
=0A@@ -4424,12 +4424,7 @@ int sd_execute_write_data(struct scsi_cmnd *srb, =
struct rtsx_chip *chip)=0A 		rtsx_init_cmd(chip);=0A 		rtsx_add_cmd(chip, C=
HECK_REG_CMD, 0xFD30, 0x02, 0x02);=0A =0A-		retval =3D rtsx_send_cmd(chip, =
SD_CARD, 250);=0A-		if (retval < 0) {=0A-			write_err =3D true;=0A-			rtsx_=
clear_sd_error(chip);=0A-			goto sd_execute_write_cmd_failed;=0A-		}=0A+		r=
tsx_send_cmd(chip, SD_CARD, 250);=0A =0A 		retval =3D sd_update_lock_status=
(chip);=0A 		if (retval !=3D STATUS_SUCCESS) {=0A-- =0A2.30.2=0A=0A=0AFrom =
ffac633f0fbe1bc87d732607b58a3e29d0316f1e Mon Sep 17 00:00:00 2001=0AFrom: S=
udip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:24:=
07 +0100=0ASubject: [PATCH 064/151] Revert "staging: rts5208: Add a check f=
or=0A ms_read_extra_data"=0A=0AThis reverts commit 73b69c01cc925d9c48e5b4f7=
8e3d8b88c4e5b924.=0A=0ACommits from @umn.edu addresses have been found to b=
e submitted in "bad=0Afaith" to try to test the kernel community's ability =
to review "known=0Amalicious" changes.  The result of these submissions can=
 be found in a=0Apaper published at the 42nd IEEE Symposium on Security and=
 Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVuln=
erabilities via Hypocrite Commits" written by Qiushi Wu (University=0Aof Mi=
nnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, al=
l submissions from this group must be reverted from=0Athe kernel tree and w=
ill need to be re-reviewed again to determine if=0Athey actually are a vali=
d fix.  Until that work is complete, remove this=0Achange to ensure that no=
 problems are being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sud=
ip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/staging/rts5208/=
ms.c | 5 +----=0A 1 file changed, 1 insertion(+), 4 deletions(-)=0A=0Adiff =
--git a/drivers/staging/rts5208/ms.c b/drivers/staging/rts5208/ms.c=0Aindex=
 e853fa9cc950..e2e76a1e673d 100644=0A--- a/drivers/staging/rts5208/ms.c=0A+=
++ b/drivers/staging/rts5208/ms.c=0A@@ -1665,10 +1665,7 @@ static int ms_co=
py_page(struct rtsx_chip *chip, u16 old_blk, u16 new_blk,=0A 			return STAT=
US_FAIL;=0A 		}=0A =0A-		retval =3D ms_read_extra_data(chip, old_blk, i, ex=
tra,=0A-					    MS_EXTRA_SIZE);=0A-		if (retval !=3D STATUS_SUCCESS)=0A-		=
	return STATUS_FAIL;=0A+		ms_read_extra_data(chip, old_blk, i, extra, MS_EX=
TRA_SIZE);=0A =0A 		retval =3D ms_set_rw_reg_addr(chip, OverwriteFlag,=0A 	=
				    MS_EXTRA_SIZE, SystemParm, 6);=0A-- =0A2.30.2=0A=0A=0AFrom 803e39c8=
394270939a28215662ed5cd0116d704c Mon Sep 17 00:00:00 2001=0AFrom: Sudip Muk=
herjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:24:07 +0100=
=0ASubject: [PATCH 065/151] Revert "dmaengine: qcom_hidma: Check for driver=
=0A register failure"=0A=0AThis reverts commit a474b3f0428d6b02a538aa10b3c3=
b722751cb382.=0A=0ACommits from @umn.edu addresses have been found to be su=
bmitted in "bad=0Afaith" to try to test the kernel community's ability to r=
eview "known=0Amalicious" changes.  The result of these submissions can be =
found in a=0Apaper published at the 42nd IEEE Symposium on Security and Pri=
vacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVulnerab=
ilities via Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnes=
ota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, all su=
bmissions from this group must be reverted from=0Athe kernel tree and will =
need to be re-reviewed again to determine if=0Athey actually are a valid fi=
x.  Until that work is complete, remove this=0Achange to ensure that no pro=
blems are being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip M=
ukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/dma/qcom/hidma_mgmt.=
c | 3 ++-=0A 1 file changed, 2 insertions(+), 1 deletion(-)=0A=0Adiff --git=
 a/drivers/dma/qcom/hidma_mgmt.c b/drivers/dma/qcom/hidma_mgmt.c=0Aindex 80=
6ca02c52d7..fe87b01f7a4e 100644=0A--- a/drivers/dma/qcom/hidma_mgmt.c=0A+++=
 b/drivers/dma/qcom/hidma_mgmt.c=0A@@ -418,8 +418,9 @@ static int __init hi=
dma_mgmt_init(void)=0A 		hidma_mgmt_of_populate_channels(child);=0A 	}=0A #=
endif=0A-	return platform_driver_register(&hidma_mgmt_driver);=0A+	platform=
_driver_register(&hidma_mgmt_driver);=0A =0A+	return 0;=0A }=0A module_init=
(hidma_mgmt_init);=0A MODULE_LICENSE("GPL v2");=0A-- =0A2.30.2=0A=0A=0AFrom=
 8d5030bd7f9527a65fd3e6a8b9fa766ba5ac466d Mon Sep 17 00:00:00 2001=0AFrom: =
Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:24=
:08 +0100=0ASubject: [PATCH 066/151] Revert "leds: lp5523: fix a missing ch=
eck of return=0A value of lp55xx_read"=0A=0AThis reverts commit 248b57015f3=
5c94d4eae2fdd8c6febf5cd703900.=0A=0ACommits from @umn.edu addresses have be=
en found to be submitted in "bad=0Afaith" to try to test the kernel communi=
ty's ability to review "known=0Amalicious" changes.  The result of these su=
bmissions can be found in a=0Apaper published at the 42nd IEEE Symposium on=
 Security and Privacy=0Aentitled, "Open Source Insecurity: Stealthily Intro=
ducing=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu (Unive=
rsity=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecaus=
e of this, all submissions from this group must be reverted from=0Athe kern=
el tree and will need to be re-reviewed again to determine if=0Athey actual=
ly are a valid fix.  Until that work is complete, remove this=0Achange to e=
nsure that no problems are being introduced into the=0Acodebase.=0A=0ASigne=
d-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/led=
s/leds-lp5523.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 deletions(-)=
=0A=0Adiff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c=
=0Aindex d0b931a136b9..76c664d6e1a4 100644=0A--- a/drivers/leds/leds-lp5523=
=2Ec=0A+++ b/drivers/leds/leds-lp5523.c=0A@@ -305,9 +305,7 @@ static int lp=
5523_init_program_engine(struct lp55xx_chip *chip)=0A =0A 	/* Let the progr=
ams run for couple of ms and check the engine status */=0A 	usleep_range(30=
00, 6000);=0A-	ret =3D lp55xx_read(chip, LP5523_REG_STATUS, &status);=0A-	i=
f (ret)=0A-		return ret;=0A+	lp55xx_read(chip, LP5523_REG_STATUS, &status);=
=0A 	status &=3D LP5523_ENG_STATUS_MASK;=0A =0A 	if (status !=3D LP5523_ENG=
_STATUS_MASK) {=0A-- =0A2.30.2=0A=0A=0AFrom 66355d9c2a9a521da8ff2da2f6de361=
fc4c12e5d Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherje=
e@gmail.com>=0ADate: Wed, 21 Apr 2021 20:24:08 +0100=0ASubject: [PATCH 067/=
151] Revert "iio: ad9523: fix a missing check of return=0A value"=0A=0AThis=
 reverts commit ae0b3773721f08526c850e2d8dec85bdb870cd12.=0A=0ACommits from=
 @umn.edu addresses have been found to be submitted in "bad=0Afaith" to try=
 to test the kernel community's ability to review "known=0Amalicious" chang=
es.  The result of these submissions can be found in a=0Apaper published at=
 the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Open Source I=
nsecurity: Stealthily Introducing=0AVulnerabilities via Hypocrite Commits" =
written by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (University=
 of Minnesota).=0A=0ABecause of this, all submissions from this group must =
be reverted from=0Athe kernel tree and will need to be re-reviewed again to=
 determine if=0Athey actually are a valid fix.  Until that work is complete=
, remove this=0Achange to ensure that no problems are being introduced into=
 the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmai=
l.com>=0A---=0A drivers/iio/frequency/ad9523.c | 7 ++-----=0A 1 file change=
d, 2 insertions(+), 5 deletions(-)=0A=0Adiff --git a/drivers/iio/frequency/=
ad9523.c b/drivers/iio/frequency/ad9523.c=0Aindex a7322184cbdd..36a26631f62=
c 100644=0A--- a/drivers/iio/frequency/ad9523.c=0A+++ b/drivers/iio/frequen=
cy/ad9523.c=0A@@ -944,14 +944,11 @@ static int ad9523_setup(struct iio_dev =
*indio_dev)=0A 		}=0A 	}=0A =0A-	for_each_clear_bit(i, &active_mask, AD9523=
_NUM_CHAN) {=0A-		ret =3D ad9523_write(indio_dev,=0A+	for_each_clear_bit(i,=
 &active_mask, AD9523_NUM_CHAN)=0A+		ad9523_write(indio_dev,=0A 			     AD9=
523_CHANNEL_CLOCK_DIST(i),=0A 			     AD9523_CLK_DIST_DRIVER_MODE(TRISTATE)=
 |=0A 			     AD9523_CLK_DIST_PWR_DOWN_EN);=0A-		if (ret < 0)=0A-			return =
ret;=0A-	}=0A =0A 	ret =3D ad9523_write(indio_dev, AD9523_POWER_DOWN_CTRL, =
0);=0A 	if (ret < 0)=0A-- =0A2.30.2=0A=0A=0AFrom 1d3a81a20ea90b8d98b7f78dea=
e8b060b6bc621f Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.muk=
herjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:24:09 +0100=0ASubject: [PATCH=
 068/151] Revert "mfd: mc13xxx: Fix a missing check of a=0A register-read f=
ailure"=0A=0AThis reverts commit 9e28989d41c0eab57ec0bb156617a8757406ff8a.=
=0A=0ACommits from @umn.edu addresses have been found to be submitted in "b=
ad=0Afaith" to try to test the kernel community's ability to review "known=
=0Amalicious" changes.  The result of these submissions can be found in a=
=0Apaper published at the 42nd IEEE Symposium on Security and Privacy=0Aent=
itled, "Open Source Insecurity: Stealthily Introducing=0AVulnerabilities vi=
a Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnesota) and K=
angjie Lu (University of Minnesota).=0A=0ABecause of this, all submissions =
=66rom this group must be reverted from=0Athe kernel tree and will need to =
be re-reviewed again to determine if=0Athey actually are a valid fix.  Unti=
l that work is complete, remove this=0Achange to ensure that no problems ar=
e being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee=
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/mfd/mc13xxx-core.c | 4 +---=
=0A 1 file changed, 1 insertion(+), 3 deletions(-)=0A=0Adiff --git a/driver=
s/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c=0Aindex 1abe7432aad8..b2b=
eb7c39cc5 100644=0A--- a/drivers/mfd/mc13xxx-core.c=0A+++ b/drivers/mfd/mc1=
3xxx-core.c=0A@@ -271,9 +271,7 @@ int mc13xxx_adc_do_conversion(struct mc13=
xxx *mc13xxx, unsigned int mode,=0A =0A 	mc13xxx->adcflags |=3D MC13XXX_ADC=
_WORKING;=0A =0A-	ret =3D mc13xxx_reg_read(mc13xxx, MC13XXX_ADC0, &old_adc0=
);=0A-	if (ret)=0A-		goto out;=0A+	mc13xxx_reg_read(mc13xxx, MC13XXX_ADC0, =
&old_adc0);=0A =0A 	adc0 =3D MC13XXX_ADC0_ADINC1 | MC13XXX_ADC0_ADINC2 |=0A=
 	       MC13XXX_ADC0_CHRGRAWDIV;=0A-- =0A2.30.2=0A=0A=0AFrom c79a12cb883a6=
1a443f61db6e38db6939055f5ab Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherje=
e <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:24:09 +0100=0ASu=
bject: [PATCH 069/151] Revert "gdrom: fix a memory leak bug"=0A=0AThis reve=
rts commit 093c48213ee37c3c3ff1cf5ac1aa2a9d8bc66017.=0A=0ACommits from @umn=
=2Eedu addresses have been found to be submitted in "bad=0Afaith" to try to=
 test the kernel community's ability to review "known=0Amalicious" changes.=
  The result of these submissions can be found in a=0Apaper published at th=
e 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Open Source Inse=
curity: Stealthily Introducing=0AVulnerabilities via Hypocrite Commits" wri=
tten by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (University of=
 Minnesota).=0A=0ABecause of this, all submissions from this group must be =
reverted from=0Athe kernel tree and will need to be re-reviewed again to de=
termine if=0Athey actually are a valid fix.  Until that work is complete, r=
emove this=0Achange to ensure that no problems are being introduced into th=
e=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.c=
om>=0A---=0A drivers/cdrom/gdrom.c | 1 -=0A 1 file changed, 1 deletion(-)=
=0A=0Adiff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c=0Aindex 66=
26c84f66d1..6988af381101 100644=0A--- a/drivers/cdrom/gdrom.c=0A+++ b/drive=
rs/cdrom/gdrom.c=0A@@ -860,7 +860,6 @@ static void __exit exit_gdrom(void)=
=0A 	platform_device_unregister(pd);=0A 	platform_driver_unregister(&gdrom_=
driver);=0A 	kfree(gd.toc);=0A-	kfree(gd.cd_info);=0A }=0A =0A module_init(=
init_gdrom);=0A-- =0A2.30.2=0A=0A=0AFrom e1bdd8c63df70ca96fe999a5dccc912d9d=
46c99c Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@g=
mail.com>=0ADate: Wed, 21 Apr 2021 20:24:10 +0100=0ASubject: [PATCH 070/151=
] Revert "net: marvell: fix a missing check of=0A acpi_match_device"=0A=0AT=
his reverts commit 92ee77d148bf06d8c52664be4d1b862583fd5c0e.=0A=0ACommits f=
rom @umn.edu addresses have been found to be submitted in "bad=0Afaith" to =
try to test the kernel community's ability to review "known=0Amalicious" ch=
anges.  The result of these submissions can be found in a=0Apaper published=
 at the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Open Sourc=
e Insecurity: Stealthily Introducing=0AVulnerabilities via Hypocrite Commit=
s" written by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (Univers=
ity of Minnesota).=0A=0ABecause of this, all submissions from this group mu=
st be reverted from=0Athe kernel tree and will need to be re-reviewed again=
 to determine if=0Athey actually are a valid fix.  Until that work is compl=
ete, remove this=0Achange to ensure that no problems are being introduced i=
nto the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@g=
mail.com>=0A---=0A drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 2 --=
=0A 1 file changed, 2 deletions(-)=0A=0Adiff --git a/drivers/net/ethernet/m=
arvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c=
=0Aindex 491bcfd36ac2..a34eb29f8eff 100644=0A--- a/drivers/net/ethernet/mar=
vell/mvpp2/mvpp2_main.c=0A+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_ma=
in.c=0A@@ -5716,8 +5716,6 @@ static int mvpp2_probe(struct platform_device =
*pdev)=0A 	if (has_acpi_companion(&pdev->dev)) {=0A 		acpi_id =3D acpi_matc=
h_device(pdev->dev.driver->acpi_match_table,=0A 					    &pdev->dev);=0A-		=
if (!acpi_id)=0A-			return -EINVAL;=0A 		priv->hw_version =3D (unsigned lon=
g)acpi_id->driver_data;=0A 	} else {=0A 		priv->hw_version =3D=0A-- =0A2.30=
=2E2=0A=0A=0AFrom 32ab3a3e2854653f93cf351fb9958b1316b3ec02 Mon Sep 17 00:00=
:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, =
21 Apr 2021 20:24:10 +0100=0ASubject: [PATCH 071/151] Revert "atl1e: checki=
ng the status of=0A atl1e_write_phy_reg"=0A=0AThis reverts commit ff07d48d7=
bc0974d4f96a85a4df14564fb09f1ef.=0A=0ACommits from @umn.edu addresses have =
been found to be submitted in "bad=0Afaith" to try to test the kernel commu=
nity's ability to review "known=0Amalicious" changes.  The result of these =
submissions can be found in a=0Apaper published at the 42nd IEEE Symposium =
on Security and Privacy=0Aentitled, "Open Source Insecurity: Stealthily Int=
roducing=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu (Uni=
versity=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABeca=
use of this, all submissions from this group must be reverted from=0Athe ke=
rnel tree and will need to be re-reviewed again to determine if=0Athey actu=
ally are a valid fix.  Until that work is complete, remove this=0Achange to=
 ensure that no problems are being introduced into the=0Acodebase.=0A=0ASig=
ned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/n=
et/ethernet/atheros/atl1e/atl1e_main.c | 4 +---=0A 1 file changed, 1 insert=
ion(+), 3 deletions(-)=0A=0Adiff --git a/drivers/net/ethernet/atheros/atl1e=
/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c=0Aindex 4f7=
b65825c15..47d6f2b68bdd 100644=0A--- a/drivers/net/ethernet/atheros/atl1e/a=
tl1e_main.c=0A+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c=0A@@ -4=
60,9 +460,7 @@ static void atl1e_mdio_write(struct net_device *netdev, int =
phy_id,=0A {=0A 	struct atl1e_adapter *adapter =3D netdev_priv(netdev);=0A =
=0A-	if (atl1e_write_phy_reg(&adapter->hw,=0A-				reg_num & MDIO_REG_ADDR_M=
ASK, val))=0A-		netdev_err(netdev, "write phy register failed\n");=0A+	atl1=
e_write_phy_reg(&adapter->hw, reg_num & MDIO_REG_ADDR_MASK, val);=0A }=0A =
=0A static int atl1e_mii_ioctl(struct net_device *netdev,=0A-- =0A2.30.2=0A=
=0A=0AFrom bf815c852b9c873cb3075d616696f946f70e451f Mon Sep 17 00:00:00 200=
1=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr =
2021 20:24:11 +0100=0ASubject: [PATCH 072/151] Revert "net: dsa: bcm_sf2: P=
ropagate error value from=0A mdio_write"=0A=0AThis reverts commit e49505f72=
55be8ced695919c08a29bf2c3d79616.=0A=0ACommits from @umn.edu addresses have =
been found to be submitted in "bad=0Afaith" to try to test the kernel commu=
nity's ability to review "known=0Amalicious" changes.  The result of these =
submissions can be found in a=0Apaper published at the 42nd IEEE Symposium =
on Security and Privacy=0Aentitled, "Open Source Insecurity: Stealthily Int=
roducing=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu (Uni=
versity=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABeca=
use of this, all submissions from this group must be reverted from=0Athe ke=
rnel tree and will need to be re-reviewed again to determine if=0Athey actu=
ally are a valid fix.  Until that work is complete, remove this=0Achange to=
 ensure that no problems are being introduced into the=0Acodebase.=0A=0ASig=
ned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/n=
et/dsa/bcm_sf2.c | 7 ++++---=0A 1 file changed, 4 insertions(+), 3 deletion=
s(-)=0A=0Adiff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.=
c=0Aindex 0ee1c0a7b165..9102cf888bc8 100644=0A--- a/drivers/net/dsa/bcm_sf2=
=2Ec=0A+++ b/drivers/net/dsa/bcm_sf2.c=0A@@ -303,10 +303,11 @@ static int b=
cm_sf2_sw_mdio_write(struct mii_bus *bus, int addr, int regnum,=0A 	 * send=
 them to our master MDIO bus controller=0A 	 */=0A 	if (addr =3D=3D BRCM_PS=
EUDO_PHY_ADDR && priv->indir_phy_mask & BIT(addr))=0A-		return bcm_sf2_sw_i=
ndir_rw(priv, 0, addr, regnum, val);=0A+		bcm_sf2_sw_indir_rw(priv, 0, addr=
, regnum, val);=0A 	else=0A-		return mdiobus_write_nested(priv->master_mii_=
bus, addr,=0A-				regnum, val);=0A+		mdiobus_write_nested(priv->master_mii_=
bus, addr, regnum, val);=0A+=0A+	return 0;=0A }=0A =0A static irqreturn_t b=
cm_sf2_switch_0_isr(int irq, void *dev_id)=0A-- =0A2.30.2=0A=0A=0AFrom 05b8=
dc774c539deeceaae428c8deaaa1ddc48dda Mon Sep 17 00:00:00 2001=0AFrom: Sudip=
 Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:24:11 +=
0100=0ASubject: [PATCH 073/151] Revert "net: stmicro: fix a missing check o=
f=0A clk_prepare"=0A=0AThis reverts commit f86a3b83833e7cfe558ca4d70b64ebc4=
8903efec.=0A=0ACommits from @umn.edu addresses have been found to be submit=
ted in "bad=0Afaith" to try to test the kernel community's ability to revie=
w "known=0Amalicious" changes.  The result of these submissions can be foun=
d in a=0Apaper published at the 42nd IEEE Symposium on Security and Privacy=
=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVulnerabilit=
ies via Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnesota)=
 and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, all submis=
sions from this group must be reverted from=0Athe kernel tree and will need=
 to be re-reviewed again to determine if=0Athey actually are a valid fix.  =
Until that work is complete, remove this=0Achange to ensure that no problem=
s are being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukhe=
rjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/ethernet/stmicro/stm=
mac/dwmac-sunxi.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 deletions(-=
)=0A=0Adiff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c b/dri=
vers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c=0Aindex 65a3e3b5face..91f45c=
2b32e9 100644=0A--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c=0A+=
++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c=0A@@ -50,9 +50,7 @@ =
static int sun7i_gmac_init(struct platform_device *pdev, void *priv)=0A 		g=
mac->clk_enabled =3D 1;=0A 	} else {=0A 		clk_set_rate(gmac->tx_clk, SUN7I_=
GMAC_MII_RATE);=0A-		ret =3D clk_prepare(gmac->tx_clk);=0A-		if (ret)=0A-		=
	return ret;=0A+		clk_prepare(gmac->tx_clk);=0A 	}=0A =0A 	return 0;=0A-- =
=0A2.30.2=0A=0A=0AFrom d304cf172264a14a1032da6ca83619a97e9c63ec Mon Sep 17 =
00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: =
Wed, 21 Apr 2021 20:24:12 +0100=0ASubject: [PATCH 074/151] Revert "media: d=
vb: Add check on sp8870_readreg"=0A=0AThis reverts commit 467a37fba93f2b4fe=
3ab597ff6a517b22b566882.=0A=0ACommits from @umn.edu addresses have been fou=
nd to be submitted in "bad=0Afaith" to try to test the kernel community's a=
bility to review "known=0Amalicious" changes.  The result of these submissi=
ons can be found in a=0Apaper published at the 42nd IEEE Symposium on Secur=
ity and Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=
=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu (University=
=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of =
this, all submissions from this group must be reverted from=0Athe kernel tr=
ee and will need to be re-reviewed again to determine if=0Athey actually ar=
e a valid fix.  Until that work is complete, remove this=0Achange to ensure=
 that no problems are being introduced into the=0Acodebase.=0A=0ASigned-off=
-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/media/dv=
b-frontends/sp8870.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 deletion=
s(-)=0A=0Adiff --git a/drivers/media/dvb-frontends/sp8870.c b/drivers/media=
/dvb-frontends/sp8870.c=0Aindex 655db8272268..ee893a2f2261 100644=0A--- a/d=
rivers/media/dvb-frontends/sp8870.c=0A+++ b/drivers/media/dvb-frontends/sp8=
870.c=0A@@ -280,9 +280,7 @@ static int sp8870_set_frontend_parameters(struc=
t dvb_frontend *fe)=0A 	sp8870_writereg(state, 0xc05, reg0xc05);=0A =0A 	//=
 read status reg in order to clear pending irqs=0A-	err =3D sp8870_readreg(=
state, 0x200);=0A-	if (err)=0A-		return err;=0A+	sp8870_readreg(state, 0x20=
0);=0A =0A 	// system controller start=0A 	sp8870_microcontroller_start(sta=
te);=0A-- =0A2.30.2=0A=0A=0AFrom 84d23c8d708a98111690cbed0009903e7b51d66a M=
on Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com=
>=0ADate: Wed, 21 Apr 2021 20:24:12 +0100=0ASubject: [PATCH 075/151] Revert=
 "net: chelsio: Add a missing check on=0A cudg_get_buffer"=0A=0AThis revert=
s commit ca19fcb6285bfce1601c073bf4b9d2942e2df8d9.=0A=0ACommits from @umn.e=
du addresses have been found to be submitted in "bad=0Afaith" to try to tes=
t the kernel community's ability to review "known=0Amalicious" changes.  Th=
e result of these submissions can be found in a=0Apaper published at the 42=
nd IEEE Symposium on Security and Privacy=0Aentitled, "Open Source Insecuri=
ty: Stealthily Introducing=0AVulnerabilities via Hypocrite Commits" written=
 by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (University of Min=
nesota).=0A=0ABecause of this, all submissions from this group must be reve=
rted from=0Athe kernel tree and will need to be re-reviewed again to determ=
ine if=0Athey actually are a valid fix.  Until that work is complete, remov=
e this=0Achange to ensure that no problems are being introduced into the=0A=
codebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=
=0A---=0A drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c | 4 ----=0A 1 file=
 changed, 4 deletions(-)=0A=0Adiff --git a/drivers/net/ethernet/chelsio/cxg=
b4/cudbg_lib.c b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c=0Aindex 780=
1425e2726..96e297f061dc 100644=0A--- a/drivers/net/ethernet/chelsio/cxgb4/c=
udbg_lib.c=0A+++ b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c=0A@@ -123=
7,10 +1237,6 @@ int cudbg_collect_hw_sched(struct cudbg_init *pdbg_init,=0A=
 =0A 	rc =3D cudbg_get_buff(pdbg_init, dbg_buff, sizeof(struct cudbg_hw_sch=
ed),=0A 			    &temp_buff);=0A-=0A-	if (rc)=0A-		return rc;=0A-=0A 	hw_sche=
d_buff =3D (struct cudbg_hw_sched *)temp_buff.data;=0A 	hw_sched_buff->map =
=3D t4_read_reg(padap, TP_TX_MOD_QUEUE_REQ_MAP_A);=0A 	hw_sched_buff->mode =
=3D TIMERMODE_G(t4_read_reg(padap, TP_MOD_CONFIG_A));=0A-- =0A2.30.2=0A=0A=
=0AFrom ebb872427e1494895a831425f26a434986291533 Mon Sep 17 00:00:00 2001=
=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2=
021 20:24:13 +0100=0ASubject: [PATCH 076/151] Revert "net: (cpts) fix a mis=
sing check of=0A clk_prepare"=0A=0AThis reverts commit 2d822f2dbab7f4c820f7=
2eb8570aacf3f35855bd.=0A=0ACommits from @umn.edu addresses have been found =
to be submitted in "bad=0Afaith" to try to test the kernel community's abil=
ity to review "known=0Amalicious" changes.  The result of these submissions=
 can be found in a=0Apaper published at the 42nd IEEE Symposium on Security=
 and Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0A=
Vulnerabilities via Hypocrite Commits" written by Qiushi Wu (University=0Ao=
f Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this=
, all submissions from this group must be reverted from=0Athe kernel tree a=
nd will need to be re-reviewed again to determine if=0Athey actually are a =
valid fix.  Until that work is complete, remove this=0Achange to ensure tha=
t no problems are being introduced into the=0Acodebase.=0A=0ASigned-off-by:=
 Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/ethernet=
/ti/cpts.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 deletions(-)=0A=0A=
diff --git a/drivers/net/ethernet/ti/cpts.c b/drivers/net/ethernet/ti/cpts.=
c=0Aindex 26cfe3f7ed8d..d0f7e864b598 100644=0A--- a/drivers/net/ethernet/ti=
/cpts.c=0A+++ b/drivers/net/ethernet/ti/cpts.c=0A@@ -661,9 +661,7 @@ struct=
 cpts *cpts_create(struct device *dev, void __iomem *regs,=0A 		return ERR_=
CAST(cpts->refclk);=0A 	}=0A =0A-	ret =3D clk_prepare(cpts->refclk);=0A-	if=
 (ret)=0A-		return ERR_PTR(ret);=0A+	clk_prepare(cpts->refclk);=0A =0A 	cpt=
s->cc.read =3D cpts_systim_read;=0A 	cpts->cc.mask =3D CLOCKSOURCE_MASK(32)=
;=0A-- =0A2.30.2=0A=0A=0AFrom 8654d383b75b52d8c42129431605f28c46dbe8bf Mon =
Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=
=0ADate: Wed, 21 Apr 2021 20:24:13 +0100=0ASubject: [PATCH 077/151] Revert =
"net/net_namespace: Check the return value of=0A register_pernet_subsys()"=
=0A=0AThis reverts commit 0eb987c874dc93f9c9d85a6465dbde20fdd3884c.=0A=0ACo=
mmits from @umn.edu addresses have been found to be submitted in "bad=0Afai=
th" to try to test the kernel community's ability to review "known=0Amalici=
ous" changes.  The result of these submissions can be found in a=0Apaper pu=
blished at the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Ope=
n Source Insecurity: Stealthily Introducing=0AVulnerabilities via Hypocrite=
 Commits" written by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (=
University of Minnesota).=0A=0ABecause of this, all submissions from this g=
roup must be reverted from=0Athe kernel tree and will need to be re-reviewe=
d again to determine if=0Athey actually are a valid fix.  Until that work i=
s complete, remove this=0Achange to ensure that no problems are being intro=
duced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukh=
erjee@gmail.com>=0A---=0A net/core/net_namespace.c | 3 +--=0A 1 file change=
d, 1 insertion(+), 2 deletions(-)=0A=0Adiff --git a/net/core/net_namespace.=
c b/net/core/net_namespace.c=0Aindex 39402840025e..c5ff1b5fc10b 100644=0A--=
- a/net/core/net_namespace.c=0A+++ b/net/core/net_namespace.c=0A@@ -1112,8 =
+1112,7 @@ static int __init net_ns_init(void)=0A 	init_net_initialized =3D=
 true;=0A 	up_write(&pernet_ops_rwsem);=0A =0A-	if (register_pernet_subsys(=
&net_ns_ops))=0A-		panic("Could not register network namespace subsystems")=
;=0A+	register_pernet_subsys(&net_ns_ops);=0A =0A 	rtnl_register(PF_UNSPEC,=
 RTM_NEWNSID, rtnl_net_newid, NULL,=0A 		      RTNL_FLAG_DOIT_UNLOCKED);=0A=
-- =0A2.30.2=0A=0A=0AFrom d44e429e3d35bc7c41f653e4a6cee121a7728b91 Mon Sep =
17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADat=
e: Wed, 21 Apr 2021 20:24:14 +0100=0ASubject: [PATCH 078/151] Revert "drive=
rs/regulator: fix a missing check of=0A return value"=0A=0AThis reverts com=
mit 966e927bf8cc6a44f8b72582a1d6d3ffc73b12ad.=0A=0ACommits from @umn.edu ad=
dresses have been found to be submitted in "bad=0Afaith" to try to test the=
 kernel community's ability to review "known=0Amalicious" changes.  The res=
ult of these submissions can be found in a=0Apaper published at the 42nd IE=
EE Symposium on Security and Privacy=0Aentitled, "Open Source Insecurity: S=
tealthily Introducing=0AVulnerabilities via Hypocrite Commits" written by Q=
iushi Wu (University=0Aof Minnesota) and Kangjie Lu (University of Minnesot=
a).=0A=0ABecause of this, all submissions from this group must be reverted =
=66rom=0Athe kernel tree and will need to be re-reviewed again to determine=
 if=0Athey actually are a valid fix.  Until that work is complete, remove t=
his=0Achange to ensure that no problems are being introduced into the=0Acod=
ebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A-=
--=0A drivers/regulator/palmas-regulator.c | 5 +----=0A 1 file changed, 1 i=
nsertion(+), 4 deletions(-)=0A=0Adiff --git a/drivers/regulator/palmas-regu=
lator.c b/drivers/regulator/palmas-regulator.c=0Aindex 31325912d311..0a7032=
11ce44 100644=0A--- a/drivers/regulator/palmas-regulator.c=0A+++ b/drivers/=
regulator/palmas-regulator.c=0A@@ -438,16 +438,13 @@ static int palmas_ldo_=
write(struct palmas *palmas, unsigned int reg,=0A static int palmas_set_mod=
e_smps(struct regulator_dev *dev, unsigned int mode)=0A {=0A 	int id =3D rd=
ev_get_id(dev);=0A-	int ret;=0A 	struct palmas_pmic *pmic =3D rdev_get_drvd=
ata(dev);=0A 	struct palmas_pmic_driver_data *ddata =3D pmic->palmas->pmic_=
ddata;=0A 	struct palmas_regs_info *rinfo =3D &ddata->palmas_regs_info[id];=
=0A 	unsigned int reg;=0A 	bool rail_enable =3D true;=0A =0A-	ret =3D palma=
s_smps_read(pmic->palmas, rinfo->ctrl_addr, &reg);=0A-	if (ret)=0A-		return=
 ret;=0A+	palmas_smps_read(pmic->palmas, rinfo->ctrl_addr, &reg);=0A =0A 	r=
eg &=3D ~PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK;=0A =0A-- =0A2.30.2=0A=0A=0AFr=
om 06c4570243e74531b70655819e8cedb22623d341 Mon Sep 17 00:00:00 2001=0AFrom=
: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:=
24:14 +0100=0ASubject: [PATCH 079/151] Revert "media: mt312: fix a missing =
check of mt312=0A reset"=0A=0AThis reverts commit 9502cdf0807058a1002948805=
2b064cecceb7fc9.=0A=0ACommits from @umn.edu addresses have been found to be=
 submitted in "bad=0Afaith" to try to test the kernel community's ability t=
o review "known=0Amalicious" changes.  The result of these submissions can =
be found in a=0Apaper published at the 42nd IEEE Symposium on Security and =
Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVulne=
rabilities via Hypocrite Commits" written by Qiushi Wu (University=0Aof Min=
nesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, all=
 submissions from this group must be reverted from=0Athe kernel tree and wi=
ll need to be re-reviewed again to determine if=0Athey actually are a valid=
 fix.  Until that work is complete, remove this=0Achange to ensure that no =
problems are being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudi=
p Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/media/dvb-fronten=
ds/mt312.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 deletions(-)=0A=0A=
diff --git a/drivers/media/dvb-frontends/mt312.c b/drivers/media/dvb-fronte=
nds/mt312.c=0Aindex 7cae7d632030..f31bac5fdb2a 100644=0A--- a/drivers/media=
/dvb-frontends/mt312.c=0A+++ b/drivers/media/dvb-frontends/mt312.c=0A@@ -63=
2,9 +632,7 @@ static int mt312_set_frontend(struct dvb_frontend *fe)=0A 	if=
 (ret < 0)=0A 		return ret;=0A =0A-	ret =3D mt312_reset(state, 0);=0A-	if (=
ret < 0)=0A-		return ret;=0A+	mt312_reset(state, 0);=0A =0A 	return 0;=0A }=
=0A-- =0A2.30.2=0A=0A=0AFrom d0d15c1ed53cdb7e4eaff572e7823b04395565a2 Mon S=
ep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A=
Date: Wed, 21 Apr 2021 20:24:15 +0100=0ASubject: [PATCH 080/151] Revert "ya=
m: fix a missing-check bug"=0A=0AThis reverts commit 0781168e23a2fc8dceb989=
f11fc5b39b3ccacc35.=0A=0ACommits from @umn.edu addresses have been found to=
 be submitted in "bad=0Afaith" to try to test the kernel community's abilit=
y to review "known=0Amalicious" changes.  The result of these submissions c=
an be found in a=0Apaper published at the 42nd IEEE Symposium on Security a=
nd Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVu=
lnerabilities via Hypocrite Commits" written by Qiushi Wu (University=0Aof =
Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, =
all submissions from this group must be reverted from=0Athe kernel tree and=
 will need to be re-reviewed again to determine if=0Athey actually are a va=
lid fix.  Until that work is complete, remove this=0Achange to ensure that =
no problems are being introduced into the=0Acodebase.=0A=0ASigned-off-by: S=
udip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/hamradio/y=
am.c | 4 ----=0A 1 file changed, 4 deletions(-)=0A=0Adiff --git a/drivers/n=
et/hamradio/yam.c b/drivers/net/hamradio/yam.c=0Aindex 5ab53e9942f3..616db3=
a0d2f4 100644=0A--- a/drivers/net/hamradio/yam.c=0A+++ b/drivers/net/hamrad=
io/yam.c=0A@@ -951,8 +951,6 @@ static int yam_ioctl(struct net_device *dev,=
 struct ifreq *ifr, int cmd)=0A 				 sizeof(struct yamdrv_ioctl_mcs));=0A 	=
	if (IS_ERR(ym))=0A 			return PTR_ERR(ym);=0A-		if (ym->cmd !=3D SIOCYAMSMC=
S)=0A-			return -EINVAL;=0A 		if (ym->bitrate > YAM_MAXBITRATE) {=0A 			kfr=
ee(ym);=0A 			return -EINVAL;=0A@@ -968,8 +966,6 @@ static int yam_ioctl(st=
ruct net_device *dev, struct ifreq *ifr, int cmd)=0A 		if (copy_from_user(&=
yi, ifr->ifr_data, sizeof(struct yamdrv_ioctl_cfg)))=0A 			 return -EFAULT;=
=0A =0A-		if (yi.cmd !=3D SIOCYAMSCFG)=0A-			return -EINVAL;=0A 		if ((yi.c=
fg.mask & YAM_IOBASE) && netif_running(dev))=0A 			return -EINVAL;		/* Cann=
ot change this parameter when up */=0A 		if ((yi.cfg.mask & YAM_IRQ) && net=
if_running(dev))=0A-- =0A2.30.2=0A=0A=0AFrom 8d42800399c8c47ffbbddd91379d93=
94e0530bdb Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherj=
ee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:24:16 +0100=0ASubject: [PATCH 081=
/151] Revert "media: gspca: Check the return value of=0A write_bridge for t=
imeout"=0A=0AThis reverts commit a21a0eb56b4e8fe4a330243af8030f890cde2283.=
=0A=0ACommits from @umn.edu addresses have been found to be submitted in "b=
ad=0Afaith" to try to test the kernel community's ability to review "known=
=0Amalicious" changes.  The result of these submissions can be found in a=
=0Apaper published at the 42nd IEEE Symposium on Security and Privacy=0Aent=
itled, "Open Source Insecurity: Stealthily Introducing=0AVulnerabilities vi=
a Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnesota) and K=
angjie Lu (University of Minnesota).=0A=0ABecause of this, all submissions =
=66rom this group must be reverted from=0Athe kernel tree and will need to =
be re-reviewed again to determine if=0Athey actually are a valid fix.  Unti=
l that work is complete, remove this=0Achange to ensure that no problems ar=
e being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee=
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/media/usb/gspca/m5602/m5602_=
po1030.c | 8 ++------=0A 1 file changed, 2 insertions(+), 6 deletions(-)=0A=
=0Adiff --git a/drivers/media/usb/gspca/m5602/m5602_po1030.c b/drivers/medi=
a/usb/gspca/m5602/m5602_po1030.c=0Aindex d680b777f097..7bdbb8065146 100644=
=0A--- a/drivers/media/usb/gspca/m5602/m5602_po1030.c=0A+++ b/drivers/media=
/usb/gspca/m5602/m5602_po1030.c=0A@@ -154,7 +154,6 @@ static const struct v=
4l2_ctrl_config po1030_greenbal_cfg =3D {=0A =0A int po1030_probe(struct sd=
 *sd)=0A {=0A-	int rc =3D 0;=0A 	u8 dev_id_h =3D 0, i;=0A 	struct gspca_dev=
 *gspca_dev =3D (struct gspca_dev *)sd;=0A =0A@@ -174,14 +173,11 @@ int po1=
030_probe(struct sd *sd)=0A 	for (i =3D 0; i < ARRAY_SIZE(preinit_po1030); =
i++) {=0A 		u8 data =3D preinit_po1030[i][2];=0A 		if (preinit_po1030[i][0]=
 =3D=3D SENSOR)=0A-			rc |=3D m5602_write_sensor(sd,=0A+			m5602_write_sens=
or(sd,=0A 				preinit_po1030[i][1], &data, 1);=0A 		else=0A-			rc |=3D m560=
2_write_bridge(sd, preinit_po1030[i][1],=0A-						data);=0A+			m5602_write_=
bridge(sd, preinit_po1030[i][1], data);=0A 	}=0A-	if (rc < 0)=0A-		return r=
c;=0A =0A 	if (m5602_read_sensor(sd, PO1030_DEVID_H, &dev_id_h, 1))=0A 		re=
turn -ENODEV;=0A-- =0A2.30.2=0A=0A=0AFrom f09acf911e2326368b256fadfde09541f=
f42ab96 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@=
gmail.com>=0ADate: Wed, 21 Apr 2021 20:24:16 +0100=0ASubject: [PATCH 082/15=
1] Revert "media: lgdt3306a: fix a missing check of=0A return value"=0A=0AT=
his reverts commit c9b7d8f252a5a6f8ca6e948151367cbc7bc4b776.=0A=0ACommits f=
rom @umn.edu addresses have been found to be submitted in "bad=0Afaith" to =
try to test the kernel community's ability to review "known=0Amalicious" ch=
anges.  The result of these submissions can be found in a=0Apaper published=
 at the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Open Sourc=
e Insecurity: Stealthily Introducing=0AVulnerabilities via Hypocrite Commit=
s" written by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (Univers=
ity of Minnesota).=0A=0ABecause of this, all submissions from this group mu=
st be reverted from=0Athe kernel tree and will need to be re-reviewed again=
 to determine if=0Athey actually are a valid fix.  Until that work is compl=
ete, remove this=0Achange to ensure that no problems are being introduced i=
nto the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@g=
mail.com>=0A---=0A drivers/media/dvb-frontends/lgdt3306a.c | 5 +----=0A 1 f=
ile changed, 1 insertion(+), 4 deletions(-)=0A=0Adiff --git a/drivers/media=
/dvb-frontends/lgdt3306a.c b/drivers/media/dvb-frontends/lgdt3306a.c=0Ainde=
x 6c4adec58174..45a9ed20a6ae 100644=0A--- a/drivers/media/dvb-frontends/lgd=
t3306a.c=0A+++ b/drivers/media/dvb-frontends/lgdt3306a.c=0A@@ -1676,10 +167=
6,7 @@ static int lgdt3306a_read_signal_strength(struct dvb_frontend *fe,=
=0A 	case QAM_256:=0A 	case QAM_AUTO:=0A 		/* need to know actual modulatio=
n to set proper SNR baseline */=0A-		ret =3D lgdt3306a_read_reg(state, 0x00=
a6, &val);=0A-		if (lg_chkerr(ret))=0A-			goto fail;=0A-=0A+		lgdt3306a_rea=
d_reg(state, 0x00a6, &val);=0A 		if(val & 0x04)=0A 			ref_snr =3D 2800; /* =
QAM-256 28dB */=0A 		else=0A-- =0A2.30.2=0A=0A=0AFrom 25431a7cc4065a0a5706c=
893874a7997c5628a0b Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudip=
m.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:24:17 +0100=0ASubject: [=
PATCH 083/151] Revert "media: usb: gspca: add a missed check for=0A goto_lo=
w_power"=0A=0AThis reverts commit 5b711870bec4dc9a6d705d41e127e73944fa3650.=
=0A=0ACommits from @umn.edu addresses have been found to be submitted in "b=
ad=0Afaith" to try to test the kernel community's ability to review "known=
=0Amalicious" changes.  The result of these submissions can be found in a=
=0Apaper published at the 42nd IEEE Symposium on Security and Privacy=0Aent=
itled, "Open Source Insecurity: Stealthily Introducing=0AVulnerabilities vi=
a Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnesota) and K=
angjie Lu (University of Minnesota).=0A=0ABecause of this, all submissions =
=66rom this group must be reverted from=0Athe kernel tree and will need to =
be re-reviewed again to determine if=0Athey actually are a valid fix.  Unti=
l that work is complete, remove this=0Achange to ensure that no problems ar=
e being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee=
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/media/usb/gspca/cpia1.c | 6 =
+-----=0A 1 file changed, 1 insertion(+), 5 deletions(-)=0A=0Adiff --git a/=
drivers/media/usb/gspca/cpia1.c b/drivers/media/usb/gspca/cpia1.c=0Aindex 5=
ee749e05267..99e594559a0c 100644=0A--- a/drivers/media/usb/gspca/cpia1.c=0A=
+++ b/drivers/media/usb/gspca/cpia1.c=0A@@ -1420,7 +1420,6 @@ static int sd=
_config(struct gspca_dev *gspca_dev,=0A {=0A 	struct sd *sd =3D (struct sd =
*) gspca_dev;=0A 	struct cam *cam;=0A-	int ret;=0A =0A 	sd->mainsFreq =3D F=
REQ_DEF =3D=3D V4L2_CID_POWER_LINE_FREQUENCY_60HZ;=0A 	reset_camera_params(=
gspca_dev);=0A@@ -1432,10 +1431,7 @@ static int sd_config(struct gspca_dev =
*gspca_dev,=0A 	cam->cam_mode =3D mode;=0A 	cam->nmodes =3D ARRAY_SIZE(mode=
);=0A =0A-	ret =3D goto_low_power(gspca_dev);=0A-	if (ret)=0A-		gspca_err(g=
spca_dev, "Cannot go to low power mode: %d\n",=0A-			  ret);=0A+	goto_low_p=
ower(gspca_dev);=0A 	/* Check the firmware version. */=0A 	sd->params.versi=
on.firmwareVersion =3D 0;=0A 	get_version_information(gspca_dev);=0A-- =0A2=
=2E30.2=0A=0A=0AFrom 92e05a4fb7a49d5b3fcf9dab06470ed025c0308c Mon Sep 17 00=
:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: We=
d, 21 Apr 2021 20:24:17 +0100=0ASubject: [PATCH 084/151] Revert "net: thund=
er: fix a potential NULL pointer=0A dereference"=0A=0AThis reverts commit 0=
b31d98d90f09868dce71319615e19cd1f146fb6.=0A=0ACommits from @umn.edu address=
es have been found to be submitted in "bad=0Afaith" to try to test the kern=
el community's ability to review "known=0Amalicious" changes.  The result o=
f these submissions can be found in a=0Apaper published at the 42nd IEEE Sy=
mposium on Security and Privacy=0Aentitled, "Open Source Insecurity: Stealt=
hily Introducing=0AVulnerabilities via Hypocrite Commits" written by Qiushi=
 Wu (University=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=
=0A=0ABecause of this, all submissions from this group must be reverted fro=
m=0Athe kernel tree and will need to be re-reviewed again to determine if=
=0Athey actually are a valid fix.  Until that work is complete, remove this=
=0Achange to ensure that no problems are being introduced into the=0Acodeba=
se.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=
=0A drivers/net/ethernet/cavium/thunder/nicvf_main.c | 6 ------=0A 1 file c=
hanged, 6 deletions(-)=0A=0Adiff --git a/drivers/net/ethernet/cavium/thunde=
r/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c=0Aindex 5=
c45c0c6dd23..560af975c4d0 100644=0A--- a/drivers/net/ethernet/cavium/thunde=
r/nicvf_main.c=0A+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c=0A@=
@ -2256,12 +2256,6 @@ static int nicvf_probe(struct pci_dev *pdev, const st=
ruct pci_device_id *ent)=0A 	nic->nicvf_rx_mode_wq =3D alloc_ordered_workqu=
eue("nicvf_rx_mode_wq_VF%d",=0A 							WQ_MEM_RECLAIM,=0A 							nic->vf_id=
);=0A-	if (!nic->nicvf_rx_mode_wq) {=0A-		err =3D -ENOMEM;=0A-		dev_err(dev=
, "Failed to allocate work queue\n");=0A-		goto err_unregister_interrupts;=
=0A-	}=0A-=0A 	INIT_WORK(&nic->rx_mode_work.work, nicvf_set_rx_mode_task);=
=0A 	spin_lock_init(&nic->rx_mode_wq_lock);=0A =0A-- =0A2.30.2=0A=0A=0AFrom=
 c7fc952088559242f18ded8f0891049153906f71 Mon Sep 17 00:00:00 2001=0AFrom: =
Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:24=
:18 +0100=0ASubject: [PATCH 085/151] Revert "media: dvb: add return value c=
heck on=0A Write16"=0A=0AThis reverts commit 0f787c12ee7b2b41a74594ed158a01=
12736f4e4e.=0A=0ACommits from @umn.edu addresses have been found to be subm=
itted in "bad=0Afaith" to try to test the kernel community's ability to rev=
iew "known=0Amalicious" changes.  The result of these submissions can be fo=
und in a=0Apaper published at the 42nd IEEE Symposium on Security and Priva=
cy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVulnerabil=
ities via Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnesot=
a) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, all subm=
issions from this group must be reverted from=0Athe kernel tree and will ne=
ed to be re-reviewed again to determine if=0Athey actually are a valid fix.=
  Until that work is complete, remove this=0Achange to ensure that no probl=
ems are being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Muk=
herjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/media/dvb-frontends/dr=
xd_hard.c | 30 +++++++++----------------=0A 1 file changed, 11 insertions(+=
), 19 deletions(-)=0A=0Adiff --git a/drivers/media/dvb-frontends/drxd_hard.=
c b/drivers/media/dvb-frontends/drxd_hard.c=0Aindex fae6f3763364..69ebc9543=
0fe 100644=0A--- a/drivers/media/dvb-frontends/drxd_hard.c=0A+++ b/drivers/=
media/dvb-frontends/drxd_hard.c=0A@@ -1132,8 +1132,6 @@ static int EnableAn=
dResetMB(struct drxd_state *state)=0A =0A static int InitCC(struct drxd_sta=
te *state)=0A {=0A-	int status =3D 0;=0A-=0A 	if (state->osc_clock_freq =3D=
=3D 0 ||=0A 	    state->osc_clock_freq > 20000 ||=0A 	    (state->osc_clock=
_freq % 4000) !=3D 0) {=0A@@ -1141,17 +1139,14 @@ static int InitCC(struct =
drxd_state *state)=0A 		return -1;=0A 	}=0A =0A-	status |=3D Write16(state,=
 CC_REG_OSC_MODE__A, CC_REG_OSC_MODE_M20, 0);=0A-	status |=3D Write16(state=
, CC_REG_PLL_MODE__A,=0A-				CC_REG_PLL_MODE_BYPASS_PLL |=0A-				CC_REG_PLL=
_MODE_PUMP_CUR_12, 0);=0A-	status |=3D Write16(state, CC_REG_REF_DIVIDE__A,=
=0A-				state->osc_clock_freq / 4000, 0);=0A-	status |=3D Write16(state, CC=
_REG_PWD_MODE__A, CC_REG_PWD_MODE_DOWN_PLL,=0A-				0);=0A-	status |=3D Writ=
e16(state, CC_REG_UPDATE__A, CC_REG_UPDATE_KEY, 0);=0A+	Write16(state, CC_R=
EG_OSC_MODE__A, CC_REG_OSC_MODE_M20, 0);=0A+	Write16(state, CC_REG_PLL_MODE=
__A, CC_REG_PLL_MODE_BYPASS_PLL |=0A+		CC_REG_PLL_MODE_PUMP_CUR_12, 0);=0A+=
	Write16(state, CC_REG_REF_DIVIDE__A, state->osc_clock_freq / 4000, 0);=0A+=
	Write16(state, CC_REG_PWD_MODE__A, CC_REG_PWD_MODE_DOWN_PLL, 0);=0A+	Write=
16(state, CC_REG_UPDATE__A, CC_REG_UPDATE_KEY, 0);=0A =0A-	return status;=
=0A+	return 0;=0A }=0A =0A static int ResetECOD(struct drxd_state *state)=
=0A@@ -1305,10 +1300,7 @@ static int SC_SendCommand(struct drxd_state *stat=
e, u16 cmd)=0A 	int status =3D 0, ret;=0A 	u16 errCode;=0A =0A-	status =3D =
Write16(state, SC_RA_RAM_CMD__A, cmd, 0);=0A-	if (status < 0)=0A-		return s=
tatus;=0A-=0A+	Write16(state, SC_RA_RAM_CMD__A, cmd, 0);=0A 	SC_WaitForRead=
y(state);=0A =0A 	ret =3D Read16(state, SC_RA_RAM_CMD_ADDR__A, &errCode, 0)=
;=0A@@ -1335,9 +1327,9 @@ static int SC_ProcStartCommand(struct drxd_state =
*state,=0A 			break;=0A 		}=0A 		SC_WaitForReady(state);=0A-		status |=3D W=
rite16(state, SC_RA_RAM_CMD_ADDR__A, subCmd, 0);=0A-		status |=3D Write16(s=
tate, SC_RA_RAM_PARAM1__A, param1, 0);=0A-		status |=3D Write16(state, SC_R=
A_RAM_PARAM0__A, param0, 0);=0A+		Write16(state, SC_RA_RAM_CMD_ADDR__A, sub=
Cmd, 0);=0A+		Write16(state, SC_RA_RAM_PARAM1__A, param1, 0);=0A+		Write16(=
state, SC_RA_RAM_PARAM0__A, param0, 0);=0A =0A 		SC_SendCommand(state, SC_R=
A_RAM_CMD_PROC_START);=0A 	} while (0);=0A-- =0A2.30.2=0A=0A=0AFrom c8c1457=
dc7916eb531389403cb218870563cdaf5 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mu=
kherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:24:18 +010=
0=0ASubject: [PATCH 086/151] Revert "hwmon: (lm80) fix a missing check of b=
us read=0A in lm80 probe"=0A=0AThis reverts commit 9aa3aa15f4c2f74f47afd6c5=
db4b420fadf3f315.=0A=0ACommits from @umn.edu addresses have been found to b=
e submitted in "bad=0Afaith" to try to test the kernel community's ability =
to review "known=0Amalicious" changes.  The result of these submissions can=
 be found in a=0Apaper published at the 42nd IEEE Symposium on Security and=
 Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVuln=
erabilities via Hypocrite Commits" written by Qiushi Wu (University=0Aof Mi=
nnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, al=
l submissions from this group must be reverted from=0Athe kernel tree and w=
ill need to be re-reviewed again to determine if=0Athey actually are a vali=
d fix.  Until that work is complete, remove this=0Achange to ensure that no=
 problems are being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sud=
ip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/hwmon/lm80.c | 1=
1 ++---------=0A 1 file changed, 2 insertions(+), 9 deletions(-)=0A=0Adiff =
--git a/drivers/hwmon/lm80.c b/drivers/hwmon/lm80.c=0Aindex 80520cef7617..e=
34cdc42575d 100644=0A--- a/drivers/hwmon/lm80.c=0A+++ b/drivers/hwmon/lm80.=
c=0A@@ -597,7 +597,6 @@ static int lm80_probe(struct i2c_client *client,=0A=
 	struct device *dev =3D &client->dev;=0A 	struct device *hwmon_dev;=0A 	st=
ruct lm80_data *data;=0A-	int rv;=0A =0A 	data =3D devm_kzalloc(dev, sizeof=
(struct lm80_data), GFP_KERNEL);=0A 	if (!data)=0A@@ -610,14 +609,8 @@ stat=
ic int lm80_probe(struct i2c_client *client,=0A 	lm80_init_client(client);=
=0A =0A 	/* A few vars need to be filled upon startup */=0A-	rv =3D lm80_re=
ad_value(client, LM80_REG_FAN_MIN(1));=0A-	if (rv < 0)=0A-		return rv;=0A-	=
data->fan[f_min][0] =3D rv;=0A-	rv =3D lm80_read_value(client, LM80_REG_FAN=
_MIN(2));=0A-	if (rv < 0)=0A-		return rv;=0A-	data->fan[f_min][1] =3D rv;=
=0A+	data->fan[f_min][0] =3D lm80_read_value(client, LM80_REG_FAN_MIN(1));=
=0A+	data->fan[f_min][1] =3D lm80_read_value(client, LM80_REG_FAN_MIN(2));=
=0A =0A 	hwmon_dev =3D devm_hwmon_device_register_with_groups(dev, client->=
name,=0A 							   data, lm80_groups);=0A-- =0A2.30.2=0A=0A=0AFrom a5c91bd7=
75f5f1b1fb22c300f046b006dad7a70b Mon Sep 17 00:00:00 2001=0AFrom: Sudip Muk=
herjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:24:19 +0100=
=0ASubject: [PATCH 087/151] Revert "net: liquidio: fix a NULL pointer=0A de=
reference"=0A=0AThis reverts commit fe543b2f174f34a7a751aa08b334fe6b105c456=
9.=0A=0ACommits from @umn.edu addresses have been found to be submitted in =
"bad=0Afaith" to try to test the kernel community's ability to review "know=
n=0Amalicious" changes.  The result of these submissions can be found in a=
=0Apaper published at the 42nd IEEE Symposium on Security and Privacy=0Aent=
itled, "Open Source Insecurity: Stealthily Introducing=0AVulnerabilities vi=
a Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnesota) and K=
angjie Lu (University of Minnesota).=0A=0ABecause of this, all submissions =
=66rom this group must be reverted from=0Athe kernel tree and will need to =
be re-reviewed again to determine if=0Athey actually are a valid fix.  Unti=
l that work is complete, remove this=0Achange to ensure that no problems ar=
e being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee=
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/ethernet/cavium/liquidio=
/lio_main.c | 5 -----=0A 1 file changed, 5 deletions(-)=0A=0Adiff --git a/d=
rivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/caviu=
m/liquidio/lio_main.c=0Aindex 7f3b2e3b0868..f2d486583e2f 100644=0A--- a/dri=
vers/net/ethernet/cavium/liquidio/lio_main.c=0A+++ b/drivers/net/ethernet/c=
avium/liquidio/lio_main.c=0A@@ -1192,11 +1192,6 @@ static void send_rx_ctrl=
_cmd(struct lio *lio, int start_stop)=0A 	sc =3D (struct octeon_soft_comman=
d *)=0A 		octeon_alloc_soft_command(oct, OCTNET_CMD_SIZE,=0A 					  16, 0);=
=0A-	if (!sc) {=0A-		netif_info(lio, rx_err, lio->netdev,=0A-			   "Failed =
to allocate octeon_soft_command\n");=0A-		return;=0A-	}=0A =0A 	ncmd =3D (u=
nion octnet_cmd *)sc->virtdptr;=0A =0A-- =0A2.30.2=0A=0A=0AFrom 77cc327987d=
76f38311bd9d6605819b53a1d218e Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukher=
jee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:24:19 +0100=0A=
Subject: [PATCH 088/151] Revert "net: cxgb3_main: fix a missing-check bug"=
=0A=0AThis reverts commit 2c05d88818ab6571816b93edce4d53703870d7ae.=0A=0ACo=
mmits from @umn.edu addresses have been found to be submitted in "bad=0Afai=
th" to try to test the kernel community's ability to review "known=0Amalici=
ous" changes.  The result of these submissions can be found in a=0Apaper pu=
blished at the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Ope=
n Source Insecurity: Stealthily Introducing=0AVulnerabilities via Hypocrite=
 Commits" written by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (=
University of Minnesota).=0A=0ABecause of this, all submissions from this g=
roup must be reverted from=0Athe kernel tree and will need to be re-reviewe=
d again to determine if=0Athey actually are a valid fix.  Until that work i=
s complete, remove this=0Achange to ensure that no problems are being intro=
duced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukh=
erjee@gmail.com>=0A---=0A drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c |=
 17 -----------------=0A 1 file changed, 17 deletions(-)=0A=0Adiff --git a/=
drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chel=
sio/cxgb3/cxgb3_main.c=0Aindex 97ff8608f0ab..ef9d5ac345c3 100644=0A--- a/dr=
ivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c=0A+++ b/drivers/net/ethernet/=
chelsio/cxgb3/cxgb3_main.c=0A@@ -2158,8 +2158,6 @@ static int cxgb_extensio=
n_ioctl(struct net_device *dev, void __user *useraddr)=0A 			return -EPERM;=
=0A 		if (copy_from_user(&t, useraddr, sizeof(t)))=0A 			return -EFAULT;=0A=
-		if (t.cmd !=3D CHELSIO_SET_QSET_PARAMS)=0A-			return -EINVAL;=0A 		if (t=
=2Eqset_idx >=3D SGE_QSETS)=0A 			return -EINVAL;=0A 		if (!in_range(t.intr=
_lat, 0, M_NEWTIMER) ||=0A@@ -2259,9 +2257,6 @@ static int cxgb_extension_i=
octl(struct net_device *dev, void __user *useraddr)=0A 		if (copy_from_user=
(&t, useraddr, sizeof(t)))=0A 			return -EFAULT;=0A =0A-		if (t.cmd !=3D CH=
ELSIO_GET_QSET_PARAMS)=0A-			return -EINVAL;=0A-=0A 		/* Display qsets for =
all ports when offload enabled */=0A 		if (test_bit(OFFLOAD_DEVMAP_BIT, &ad=
apter->open_device_map)) {=0A 			q1 =3D 0;=0A@@ -2307,8 +2302,6 @@ static i=
nt cxgb_extension_ioctl(struct net_device *dev, void __user *useraddr)=0A 	=
		return -EBUSY;=0A 		if (copy_from_user(&edata, useraddr, sizeof(edata)))=
=0A 			return -EFAULT;=0A-		if (edata.cmd !=3D CHELSIO_SET_QSET_NUM)=0A-			=
return -EINVAL;=0A 		if (edata.val < 1 ||=0A 			(edata.val > 1 && !(adapter=
->flags & USING_MSIX)))=0A 			return -EINVAL;=0A@@ -2349,8 +2342,6 @@ stati=
c int cxgb_extension_ioctl(struct net_device *dev, void __user *useraddr)=
=0A 			return -EPERM;=0A 		if (copy_from_user(&t, useraddr, sizeof(t)))=0A =
			return -EFAULT;=0A-		if (t.cmd !=3D CHELSIO_LOAD_FW)=0A-			return -EINVA=
L;=0A 		/* Check t.len sanity ? */=0A 		fw_data =3D memdup_user(useraddr + =
sizeof(t), t.len);=0A 		if (IS_ERR(fw_data))=0A@@ -2374,8 +2365,6 @@ static=
 int cxgb_extension_ioctl(struct net_device *dev, void __user *useraddr)=0A=
 			return -EBUSY;=0A 		if (copy_from_user(&m, useraddr, sizeof(m)))=0A 			=
return -EFAULT;=0A-		if (m.cmd !=3D CHELSIO_SETMTUTAB)=0A-			return -EINVAL=
;=0A 		if (m.nmtus !=3D NMTUS)=0A 			return -EINVAL;=0A 		if (m.mtus[0] < 8=
1)	/* accommodate SACK */=0A@@ -2417,8 +2406,6 @@ static int cxgb_extension=
_ioctl(struct net_device *dev, void __user *useraddr)=0A 			return -EBUSY;=
=0A 		if (copy_from_user(&m, useraddr, sizeof(m)))=0A 			return -EFAULT;=0A=
-		if (m.cmd !=3D CHELSIO_SET_PM)=0A-			return -EINVAL;=0A 		if (!is_power_=
of_2(m.rx_pg_sz) ||=0A 			!is_power_of_2(m.tx_pg_sz))=0A 			return -EINVAL;=
	/* not power of 2 */=0A@@ -2454,8 +2441,6 @@ static int cxgb_extension_ioc=
tl(struct net_device *dev, void __user *useraddr)=0A 			return -EIO;	/* nee=
d the memory controllers */=0A 		if (copy_from_user(&t, useraddr, sizeof(t)=
))=0A 			return -EFAULT;=0A-		if (t.cmd !=3D CHELSIO_GET_MEM)=0A-			return =
-EINVAL;=0A 		if ((t.addr & 7) || (t.len & 7))=0A 			return -EINVAL;=0A 		i=
f (t.mem_id =3D=3D MEM_CM)=0A@@ -2508,8 +2493,6 @@ static int cxgb_extensio=
n_ioctl(struct net_device *dev, void __user *useraddr)=0A 			return -EAGAIN=
;=0A 		if (copy_from_user(&t, useraddr, sizeof(t)))=0A 			return -EFAULT;=
=0A-		if (t.cmd !=3D CHELSIO_SET_TRACE_FILTER)=0A-			return -EINVAL;=0A =0A=
 		tp =3D (const struct trace_params *)&t.sip;=0A 		if (t.config_tx)=0A-- =
=0A2.30.2=0A=0A=0AFrom b67dfdc572b265bb561857277410d61540c0a8b0 Mon Sep 17 =
00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: =
Wed, 21 Apr 2021 20:24:20 +0100=0ASubject: [PATCH 089/151] Revert "isdn: mI=
SDNinfineon: fix potential NULL=0A pointer dereference"=0A=0AThis reverts c=
ommit d721fe99f6ada070ae8fc0ec3e01ce5a42def0d9.=0A=0ACommits from @umn.edu =
addresses have been found to be submitted in "bad=0Afaith" to try to test t=
he kernel community's ability to review "known=0Amalicious" changes.  The r=
esult of these submissions can be found in a=0Apaper published at the 42nd =
IEEE Symposium on Security and Privacy=0Aentitled, "Open Source Insecurity:=
 Stealthily Introducing=0AVulnerabilities via Hypocrite Commits" written by=
 Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (University of Minnes=
ota).=0A=0ABecause of this, all submissions from this group must be reverte=
d from=0Athe kernel tree and will need to be re-reviewed again to determine=
 if=0Athey actually are a valid fix.  Until that work is complete, remove t=
his=0Achange to ensure that no problems are being introduced into the=0Acod=
ebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A-=
--=0A drivers/isdn/hardware/mISDN/mISDNinfineon.c | 5 +----=0A 1 file chang=
ed, 1 insertion(+), 4 deletions(-)=0A=0Adiff --git a/drivers/isdn/hardware/=
mISDN/mISDNinfineon.c b/drivers/isdn/hardware/mISDN/mISDNinfineon.c=0Aindex=
 f4cb29766888..d62006bab9c6 100644=0A--- a/drivers/isdn/hardware/mISDN/mISD=
Ninfineon.c=0A+++ b/drivers/isdn/hardware/mISDN/mISDNinfineon.c=0A@@ -697,1=
1 +697,8 @@ setup_io(struct inf_hw *hw)=0A 				(ulong)hw->addr.start, (ulon=
g)hw->addr.size);=0A 			return err;=0A 		}=0A-		if (hw->ci->addr_mode =3D=
=3D AM_MEMIO) {=0A+		if (hw->ci->addr_mode =3D=3D AM_MEMIO)=0A 			hw->addr.=
p =3D ioremap(hw->addr.start, hw->addr.size);=0A-			if (unlikely(!hw->addr.=
p))=0A-				return -ENOMEM;=0A-		}=0A 		hw->addr.mode =3D hw->ci->addr_mode;=
=0A 		if (debug & DEBUG_HW)=0A 			pr_notice("%s: IO addr %lx (%lu bytes) mo=
de%d\n",=0A-- =0A2.30.2=0A=0A=0AFrom 82e441927007583b8787a45ddb1f9da5ca6a2b=
ca Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail=
=2Ecom>=0ADate: Wed, 21 Apr 2021 20:24:20 +0100=0ASubject: [PATCH 090/151] =
Revert "isdn: mISDN: Fix potential NULL pointer=0A dereference of kzalloc"=
=0A=0AThis reverts commit 38d22659803a033b1b66cd2624c33570c0dde77d.=0A=0ACo=
mmits from @umn.edu addresses have been found to be submitted in "bad=0Afai=
th" to try to test the kernel community's ability to review "known=0Amalici=
ous" changes.  The result of these submissions can be found in a=0Apaper pu=
blished at the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Ope=
n Source Insecurity: Stealthily Introducing=0AVulnerabilities via Hypocrite=
 Commits" written by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (=
University of Minnesota).=0A=0ABecause of this, all submissions from this g=
roup must be reverted from=0Athe kernel tree and will need to be re-reviewe=
d again to determine if=0Athey actually are a valid fix.  Until that work i=
s complete, remove this=0Achange to ensure that no problems are being intro=
duced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukh=
erjee@gmail.com>=0A---=0A drivers/isdn/hardware/mISDN/hfcsusb.c | 3 ---=0A =
1 file changed, 3 deletions(-)=0A=0Adiff --git a/drivers/isdn/hardware/mISD=
N/hfcsusb.c b/drivers/isdn/hardware/mISDN/hfcsusb.c=0Aindex 008a74a1ed44..7=
a051435c406 100644=0A--- a/drivers/isdn/hardware/mISDN/hfcsusb.c=0A+++ b/dr=
ivers/isdn/hardware/mISDN/hfcsusb.c=0A@@ -249,9 +249,6 @@ hfcsusb_ph_info(s=
truct hfcsusb *hw)=0A 	int i;=0A =0A 	phi =3D kzalloc(struct_size(phi, bch,=
 dch->dev.nrbchan), GFP_ATOMIC);=0A-	if (!phi)=0A-		return;=0A-=0A 	phi->dc=
h.ch.protocol =3D hw->protocol;=0A 	phi->dch.ch.Flags =3D dch->Flags;=0A 	p=
hi->dch.state =3D dch->state;=0A-- =0A2.30.2=0A=0A=0AFrom 67f352963216d9023=
eb277b59f9d375439ddfdd9 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <s=
udipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:24:21 +0100=0ASubjec=
t: [PATCH 091/151] Revert "libnvdimm/namespace: Fix a potential NULL=0A poi=
nter dereference"=0A=0AThis reverts commit 55c1fc0af29a6c1b92f217b7eb7581a8=
82e0c07c.=0A=0ACommits from @umn.edu addresses have been found to be submit=
ted in "bad=0Afaith" to try to test the kernel community's ability to revie=
w "known=0Amalicious" changes.  The result of these submissions can be foun=
d in a=0Apaper published at the 42nd IEEE Symposium on Security and Privacy=
=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVulnerabilit=
ies via Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnesota)=
 and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, all submis=
sions from this group must be reverted from=0Athe kernel tree and will need=
 to be re-reviewed again to determine if=0Athey actually are a valid fix.  =
Until that work is complete, remove this=0Achange to ensure that no problem=
s are being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukhe=
rjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/nvdimm/namespace_devs.c =
| 5 +----=0A 1 file changed, 1 insertion(+), 4 deletions(-)=0A=0Adiff --git=
 a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c=0Ainde=
x cca0a3ba1d2c..794d5709eeda 100644=0A--- a/drivers/nvdimm/namespace_devs.c=
=0A+++ b/drivers/nvdimm/namespace_devs.c=0A@@ -2256,12 +2256,9 @@ static st=
ruct device *create_namespace_blk(struct nd_region *nd_region,=0A 	if (!nsb=
lk->uuid)=0A 		goto blk_err;=0A 	memcpy(name, nd_label->name, NSLABEL_NAME_=
LEN);=0A-	if (name[0]) {=0A+	if (name[0])=0A 		nsblk->alt_name =3D kmemdup(=
name, NSLABEL_NAME_LEN,=0A 				GFP_KERNEL);=0A-		if (!nsblk->alt_name)=0A-	=
		goto blk_err;=0A-	}=0A 	res =3D nsblk_add_resource(nd_region, ndd, nsblk,=
=0A 			__le64_to_cpu(nd_label->dpa));=0A 	if (!res)=0A-- =0A2.30.2=0A=0A=0A=
=46rom ecedc732f0fe4e81826d9e20ea28e6ae3d741a6c Mon Sep 17 00:00:00 2001=0A=
=46rom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 20=
21 20:24:21 +0100=0ASubject: [PATCH 092/151] Revert "ALSA: sb: fix a missin=
g check of snd_ctl_add"=0A=0AThis reverts commit beae77170c60aa786f3e4599c1=
8ead2854d8694d.=0A=0ACommits from @umn.edu addresses have been found to be =
submitted in "bad=0Afaith" to try to test the kernel community's ability to=
 review "known=0Amalicious" changes.  The result of these submissions can b=
e found in a=0Apaper published at the 42nd IEEE Symposium on Security and P=
rivacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVulner=
abilities via Hypocrite Commits" written by Qiushi Wu (University=0Aof Minn=
esota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, all =
submissions from this group must be reverted from=0Athe kernel tree and wil=
l need to be re-reviewed again to determine if=0Athey actually are a valid =
fix.  Until that work is complete, remove this=0Achange to ensure that no p=
roblems are being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip=
 Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A sound/isa/sb/sb16_main.c |=
 10 +++-------=0A 1 file changed, 3 insertions(+), 7 deletions(-)=0A=0Adiff=
 --git a/sound/isa/sb/sb16_main.c b/sound/isa/sb/sb16_main.c=0Aindex 0768bb=
f8fd71..679f9f48370f 100644=0A--- a/sound/isa/sb/sb16_main.c=0A+++ b/sound/=
isa/sb/sb16_main.c=0A@@ -864,14 +864,10 @@ int snd_sb16dsp_pcm(struct snd_s=
b *chip, int device)=0A 	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_PLAYBACK, &s=
nd_sb16_playback_ops);=0A 	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE, &=
snd_sb16_capture_ops);=0A =0A-	if (chip->dma16 >=3D 0 && chip->dma8 !=3D ch=
ip->dma16) {=0A-		err =3D snd_ctl_add(card, snd_ctl_new1(=0A-					&snd_sb16=
_dma_control, chip));=0A-		if (err)=0A-			return err;=0A-	} else {=0A+	if (=
chip->dma16 >=3D 0 && chip->dma8 !=3D chip->dma16)=0A+		snd_ctl_add(card, s=
nd_ctl_new1(&snd_sb16_dma_control, chip));=0A+	else=0A 		pcm->info_flags =
=3D SNDRV_PCM_INFO_HALF_DUPLEX;=0A-	}=0A =0A 	snd_pcm_lib_preallocate_pages=
_for_all(pcm, SNDRV_DMA_TYPE_DEV,=0A 					      card->dev,=0A-- =0A2.30.2=
=0A=0A=0AFrom 5e1e875428720427aeaf70af62451df0de18d65a Mon Sep 17 00:00:00 =
2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 A=
pr 2021 20:24:22 +0100=0ASubject: [PATCH 093/151] Revert "brcmfmac: add a c=
heck for the status of=0A usb_register"=0A=0AThis reverts commit 42daad3343=
be4a4e1ee03e30a5f5cc731dadfef5.=0A=0ACommits from @umn.edu addresses have b=
een found to be submitted in "bad=0Afaith" to try to test the kernel commun=
ity's ability to review "known=0Amalicious" changes.  The result of these s=
ubmissions can be found in a=0Apaper published at the 42nd IEEE Symposium o=
n Security and Privacy=0Aentitled, "Open Source Insecurity: Stealthily Intr=
oducing=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu (Univ=
ersity=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecau=
se of this, all submissions from this group must be reverted from=0Athe ker=
nel tree and will need to be re-reviewed again to determine if=0Athey actua=
lly are a valid fix.  Until that work is complete, remove this=0Achange to =
ensure that no problems are being introduced into the=0Acodebase.=0A=0ASign=
ed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/ne=
t/wireless/broadcom/brcm80211/brcmfmac/usb.c | 6 +-----=0A 1 file changed, =
1 insertion(+), 5 deletions(-)=0A=0Adiff --git a/drivers/net/wireless/broad=
com/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/brcm80211/brcm=
fmac/usb.c=0Aindex 575ed19e9195..6f41d28930e4 100644=0A--- a/drivers/net/wi=
reless/broadcom/brcm80211/brcmfmac/usb.c=0A+++ b/drivers/net/wireless/broad=
com/brcm80211/brcmfmac/usb.c=0A@@ -1560,10 +1560,6 @@ void brcmf_usb_exit(v=
oid)=0A =0A void brcmf_usb_register(void)=0A {=0A-	int ret;=0A-=0A 	brcmf_d=
bg(USB, "Enter\n");=0A-	ret =3D usb_register(&brcmf_usbdrvr);=0A-	if (ret)=
=0A-		brcmf_err("usb_register failed %d\n", ret);=0A+	usb_register(&brcmf_u=
sbdrvr);=0A }=0A-- =0A2.30.2=0A=0A=0AFrom 384f92173de41c28aa6dc6c51fadd9ae7=
92cb9b6 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@=
gmail.com>=0ADate: Wed, 21 Apr 2021 20:24:22 +0100=0ASubject: [PATCH 094/15=
1] Revert "dmaengine: mv_xor: Fix a missing check in=0A mv_xor_channel_add"=
=0A=0AThis reverts commit 7c97381e7a9a5ec359007c0d491a143e3d9f787c.=0A=0ACo=
mmits from @umn.edu addresses have been found to be submitted in "bad=0Afai=
th" to try to test the kernel community's ability to review "known=0Amalici=
ous" changes.  The result of these submissions can be found in a=0Apaper pu=
blished at the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Ope=
n Source Insecurity: Stealthily Introducing=0AVulnerabilities via Hypocrite=
 Commits" written by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (=
University of Minnesota).=0A=0ABecause of this, all submissions from this g=
roup must be reverted from=0Athe kernel tree and will need to be re-reviewe=
d again to determine if=0Athey actually are a valid fix.  Until that work i=
s complete, remove this=0Achange to ensure that no problems are being intro=
duced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukh=
erjee@gmail.com>=0A---=0A drivers/dma/mv_xor.c | 5 +----=0A 1 file changed,=
 1 insertion(+), 4 deletions(-)=0A=0Adiff --git a/drivers/dma/mv_xor.c b/dr=
ivers/dma/mv_xor.c=0Aindex 0ac8e7b34e12..fcaa42c06e0f 100644=0A--- a/driver=
s/dma/mv_xor.c=0A+++ b/drivers/dma/mv_xor.c=0A@@ -1145,10 +1145,7 @@ mv_xor=
_channel_add(struct mv_xor_device *xordev,=0A 		 dma_has_cap(DMA_MEMCPY, dm=
a_dev->cap_mask) ? "cpy " : "",=0A 		 dma_has_cap(DMA_INTERRUPT, dma_dev->c=
ap_mask) ? "intr " : "");=0A =0A-	ret =3D dma_async_device_register(dma_dev=
);=0A-	if (ret)=0A-		goto err_free_irq;=0A-=0A+	dma_async_device_register(d=
ma_dev);=0A 	return mv_chan;=0A =0A err_free_irq:=0A-- =0A2.30.2=0A=0A=0AFr=
om 3ece987ab6743c01979e65aead92e7a7865bec91 Mon Sep 17 00:00:00 2001=0AFrom=
: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:=
24:23 +0100=0ASubject: [PATCH 095/151] Revert "niu: fix missing checks of=
=0A niu_pci_eeprom_read"=0A=0AThis reverts commit 26fd962bde0b15e54234fe762=
d86bc0349df1de4.=0A=0ACommits from @umn.edu addresses have been found to be=
 submitted in "bad=0Afaith" to try to test the kernel community's ability t=
o review "known=0Amalicious" changes.  The result of these submissions can =
be found in a=0Apaper published at the 42nd IEEE Symposium on Security and =
Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVulne=
rabilities via Hypocrite Commits" written by Qiushi Wu (University=0Aof Min=
nesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, all=
 submissions from this group must be reverted from=0Athe kernel tree and wi=
ll need to be re-reviewed again to determine if=0Athey actually are a valid=
 fix.  Until that work is complete, remove this=0Achange to ensure that no =
problems are being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudi=
p Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/ethernet/sun/=
niu.c | 10 ++--------=0A 1 file changed, 2 insertions(+), 8 deletions(-)=0A=
=0Adiff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/n=
iu.c=0Aindex 2911740af706..eb8da9dd676f 100644=0A--- a/drivers/net/ethernet=
/sun/niu.c=0A+++ b/drivers/net/ethernet/sun/niu.c=0A@@ -8097,8 +8097,6 @@ s=
tatic int niu_pci_vpd_scan_props(struct niu *np, u32 start, u32 end)=0A 		s=
tart +=3D 3;=0A =0A 		prop_len =3D niu_pci_eeprom_read(np, start + 4);=0A-	=
	if (prop_len < 0)=0A-			return prop_len;=0A 		err =3D niu_pci_vpd_get_prop=
name(np, start + 5, namebuf, 64);=0A 		if (err < 0)=0A 			return err;=0A@@ =
-8143,12 +8141,8 @@ static int niu_pci_vpd_scan_props(struct niu *np, u32 s=
tart, u32 end)=0A 			netif_printk(np, probe, KERN_DEBUG, np->dev,=0A 				  =
   "VPD_SCAN: Reading in property [%s] len[%d]\n",=0A 				     namebuf, pro=
p_len);=0A-			for (i =3D 0; i < prop_len; i++) {=0A-				err =3D niu_pci_eep=
rom_read(np, off + i);=0A-				if (err >=3D 0)=0A-					*prop_buf =3D err;=0A=
-				++prop_buf;=0A-			}=0A+			for (i =3D 0; i < prop_len; i++)=0A+				*pro=
p_buf++ =3D niu_pci_eeprom_read(np, off + i);=0A 		}=0A =0A 		start +=3D le=
n;=0A-- =0A2.30.2=0A=0A=0AFrom cb4f8eae63e587e1e0e8bddd7bdac0a76fd38ef9 Mon=
 Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=
=0ADate: Wed, 21 Apr 2021 20:24:23 +0100=0ASubject: [PATCH 096/151] Revert =
"ipv6/route: Add a missing check on=0A proc_dointvec"=0A=0AThis reverts com=
mit f0fb9b288d0a7e9cc324ae362e2dfd2cc2217ded.=0A=0ACommits from @umn.edu ad=
dresses have been found to be submitted in "bad=0Afaith" to try to test the=
 kernel community's ability to review "known=0Amalicious" changes.  The res=
ult of these submissions can be found in a=0Apaper published at the 42nd IE=
EE Symposium on Security and Privacy=0Aentitled, "Open Source Insecurity: S=
tealthily Introducing=0AVulnerabilities via Hypocrite Commits" written by Q=
iushi Wu (University=0Aof Minnesota) and Kangjie Lu (University of Minnesot=
a).=0A=0ABecause of this, all submissions from this group must be reverted =
=66rom=0Athe kernel tree and will need to be re-reviewed again to determine=
 if=0Athey actually are a valid fix.  Until that work is complete, remove t=
his=0Achange to ensure that no problems are being introduced into the=0Acod=
ebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A-=
--=0A net/ipv6/route.c | 6 +-----=0A 1 file changed, 1 insertion(+), 5 dele=
tions(-)=0A=0Adiff --git a/net/ipv6/route.c b/net/ipv6/route.c=0Aindex 3a9b=
d9687e7d..74c1f7cda33f 100644=0A--- a/net/ipv6/route.c=0A+++ b/net/ipv6/rou=
te.c=0A@@ -6068,16 +6068,12 @@ int ipv6_sysctl_rtcache_flush(struct ctl_tab=
le *ctl, int write,=0A {=0A 	struct net *net;=0A 	int delay;=0A-	int ret;=
=0A 	if (!write)=0A 		return -EINVAL;=0A =0A 	net =3D (struct net *)ctl->ex=
tra1;=0A 	delay =3D net->ipv6.sysctl.flush_delay;=0A-	ret =3D proc_dointvec=
(ctl, write, buffer, lenp, ppos);=0A-	if (ret)=0A-		return ret;=0A-=0A+	pro=
c_dointvec(ctl, write, buffer, lenp, ppos);=0A 	fib6_run_gc(delay <=3D 0 ? =
0 : (unsigned long)delay, net, delay > 0);=0A 	return 0;=0A }=0A-- =0A2.30.=
2=0A=0A=0AFrom 62582ae37f70c9fefb095edae13266462cd1a77a Mon Sep 17 00:00:00=
 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 =
Apr 2021 20:24:24 +0100=0ASubject: [PATCH 097/151] Revert "net: socket: fix=
 a missing-check bug"=0A=0AThis reverts commit b6168562c8ce2bd5a30e21302165=
0422e08764dc.=0A=0ACommits from @umn.edu addresses have been found to be su=
bmitted in "bad=0Afaith" to try to test the kernel community's ability to r=
eview "known=0Amalicious" changes.  The result of these submissions can be =
found in a=0Apaper published at the 42nd IEEE Symposium on Security and Pri=
vacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVulnerab=
ilities via Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnes=
ota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, all su=
bmissions from this group must be reverted from=0Athe kernel tree and will =
need to be re-reviewed again to determine if=0Athey actually are a valid fi=
x.  Until that work is complete, remove this=0Achange to ensure that no pro=
blems are being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip M=
ukherjee <sudipm.mukherjee@gmail.com>=0A---=0A net/socket.c | 11 +++-------=
-=0A 1 file changed, 3 insertions(+), 8 deletions(-)=0A=0Adiff --git a/net/=
socket.c b/net/socket.c=0Aindex d1a0264401b7..13c2536cc97e 100644=0A--- a/n=
et/socket.c=0A+++ b/net/socket.c=0A@@ -3159,14 +3159,9 @@ static int ethtoo=
l_ioctl(struct net *net, struct compat_ifreq __user *ifr32)=0A 		    copy_i=
n_user(&rxnfc->fs.ring_cookie,=0A 				 &compat_rxnfc->fs.ring_cookie,=0A 		=
		 (void __user *)(&rxnfc->fs.location + 1) -=0A-				 (void __user *)&rxnfc=
->fs.ring_cookie))=0A-			return -EFAULT;=0A-		if (ethcmd =3D=3D ETHTOOL_GRX=
CLSRLALL) {=0A-			if (put_user(rule_cnt, &rxnfc->rule_cnt))=0A-				return -=
EFAULT;=0A-		} else if (copy_in_user(&rxnfc->rule_cnt,=0A-					&compat_rxnf=
c->rule_cnt,=0A-					sizeof(rxnfc->rule_cnt)))=0A+				 (void __user *)&rxnf=
c->fs.ring_cookie) ||=0A+		    copy_in_user(&rxnfc->rule_cnt, &compat_rxnfc=
->rule_cnt,=0A+				 sizeof(rxnfc->rule_cnt)))=0A 			return -EFAULT;=0A 	}=
=0A =0A-- =0A2.30.2=0A=0A=0AFrom 2ec729b812e95625c560deba528bd0cdbf3806a2 M=
on Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com=
>=0ADate: Wed, 21 Apr 2021 20:24:24 +0100=0ASubject: [PATCH 098/151] Revert=
 "net: netxen: fix a missing check and an=0A uninitialized use"=0A=0AThis r=
everts commit d134e486e831defd26130770181f01dfc6195f7d.=0A=0ACommits from @=
umn.edu addresses have been found to be submitted in "bad=0Afaith" to try t=
o test the kernel community's ability to review "known=0Amalicious" changes=
=2E  The result of these submissions can be found in a=0Apaper published at=
 the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Open Source I=
nsecurity: Stealthily Introducing=0AVulnerabilities via Hypocrite Commits" =
written by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (University=
 of Minnesota).=0A=0ABecause of this, all submissions from this group must =
be reverted from=0Athe kernel tree and will need to be re-reviewed again to=
 determine if=0Athey actually are a valid fix.  Until that work is complete=
, remove this=0Achange to ensure that no problems are being introduced into=
 the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmai=
l.com>=0A---=0A drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c | 3 +-=
-=0A 1 file changed, 1 insertion(+), 2 deletions(-)=0A=0Adiff --git a/drive=
rs/net/ethernet/qlogic/netxen/netxen_nic_init.c b/drivers/net/ethernet/qlog=
ic/netxen/netxen_nic_init.c=0Aindex 94546ed5f867..74335bdff701 100644=0A---=
 a/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c=0A+++ b/drivers/net=
/ethernet/qlogic/netxen/netxen_nic_init.c=0A@@ -1109,8 +1109,7 @@ netxen_va=
lidate_firmware(struct netxen_adapter *adapter)=0A 		return -EINVAL;=0A 	}=
=0A 	val =3D nx_get_bios_version(adapter);=0A-	if (netxen_rom_fast_read(ada=
pter, NX_BIOS_VERSION_OFFSET, (int *)&bios))=0A-		return -EIO;=0A+	netxen_r=
om_fast_read(adapter, NX_BIOS_VERSION_OFFSET, (int *)&bios);=0A 	if ((__for=
ce u32)val !=3D bios) {=0A 		dev_err(&pdev->dev, "%s: firmware bios is inco=
mpatible\n",=0A 				fw_name[fw_type]);=0A-- =0A2.30.2=0A=0A=0AFrom 89a54588=
636ae4e13a1c06f4a5b636192084389d Mon Sep 17 00:00:00 2001=0AFrom: Sudip Muk=
herjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:24:25 +0100=
=0ASubject: [PATCH 099/151] Revert "media: gspca: mt9m111: Check write_brid=
ge for=0A timeout"=0A=0AThis reverts commit 656025850074f5c1ba2e05be37bda57=
ba2b8d491.=0A=0ACommits from @umn.edu addresses have been found to be submi=
tted in "bad=0Afaith" to try to test the kernel community's ability to revi=
ew "known=0Amalicious" changes.  The result of these submissions can be fou=
nd in a=0Apaper published at the 42nd IEEE Symposium on Security and Privac=
y=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVulnerabili=
ties via Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnesota=
) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, all submi=
ssions from this group must be reverted from=0Athe kernel tree and will nee=
d to be re-reviewed again to determine if=0Athey actually are a valid fix. =
 Until that work is complete, remove this=0Achange to ensure that no proble=
ms are being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukh=
erjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/media/usb/gspca/m5602/m=
5602_mt9m111.c | 8 +++-----=0A 1 file changed, 3 insertions(+), 5 deletions=
(-)=0A=0Adiff --git a/drivers/media/usb/gspca/m5602/m5602_mt9m111.c b/drive=
rs/media/usb/gspca/m5602/m5602_mt9m111.c=0Aindex bfa3b381d8a2..50481dc928d0=
 100644=0A--- a/drivers/media/usb/gspca/m5602/m5602_mt9m111.c=0A+++ b/drive=
rs/media/usb/gspca/m5602/m5602_mt9m111.c=0A@@ -195,7 +195,7 @@ static const=
 struct v4l2_ctrl_config mt9m111_greenbal_cfg =3D {=0A int mt9m111_probe(st=
ruct sd *sd)=0A {=0A 	u8 data[2] =3D {0x00, 0x00};=0A-	int i, rc =3D 0;=0A+=
	int i;=0A 	struct gspca_dev *gspca_dev =3D (struct gspca_dev *)sd;=0A =0A =
	if (force_sensor) {=0A@@ -213,18 +213,16 @@ int mt9m111_probe(struct sd *s=
d)=0A 	/* Do the preinit */=0A 	for (i =3D 0; i < ARRAY_SIZE(preinit_mt9m11=
1); i++) {=0A 		if (preinit_mt9m111[i][0] =3D=3D BRIDGE) {=0A-			rc |=3D m5=
602_write_bridge(sd,=0A+			m5602_write_bridge(sd,=0A 				preinit_mt9m111[i]=
[1],=0A 				preinit_mt9m111[i][2]);=0A 		} else {=0A 			data[0] =3D preinit=
_mt9m111[i][2];=0A 			data[1] =3D preinit_mt9m111[i][3];=0A-			rc |=3D m560=
2_write_sensor(sd,=0A+			m5602_write_sensor(sd,=0A 				preinit_mt9m111[i][1=
], data, 2);=0A 		}=0A 	}=0A-	if (rc < 0)=0A-		return rc;=0A =0A 	if (m5602=
_read_sensor(sd, MT9M111_SC_CHIPVER, data, 2))=0A 		return -ENODEV;=0A-- =
=0A2.30.2=0A=0A=0AFrom a3898732bedaa55d8462757c0691ebaba9888610 Mon Sep 17 =
00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: =
Wed, 21 Apr 2021 20:24:25 +0100=0ASubject: [PATCH 100/151] Revert "ethtool:=
 fix a missing-check bug"=0A=0AThis reverts commit 2bb3207dbbd4d30e96dd0e1c=
8e013104193bd59c.=0A=0ACommits from @umn.edu addresses have been found to b=
e submitted in "bad=0Afaith" to try to test the kernel community's ability =
to review "known=0Amalicious" changes.  The result of these submissions can=
 be found in a=0Apaper published at the 42nd IEEE Symposium on Security and=
 Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVuln=
erabilities via Hypocrite Commits" written by Qiushi Wu (University=0Aof Mi=
nnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, al=
l submissions from this group must be reverted from=0Athe kernel tree and w=
ill need to be re-reviewed again to determine if=0Athey actually are a vali=
d fix.  Until that work is complete, remove this=0Achange to ensure that no=
 problems are being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sud=
ip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A net/core/ethtool.c | 3 -=
--=0A 1 file changed, 3 deletions(-)=0A=0Adiff --git a/net/core/ethtool.c b=
/net/core/ethtool.c=0Aindex cd9bc67381b2..606bb30b98cf 100644=0A--- a/net/c=
ore/ethtool.c=0A+++ b/net/core/ethtool.c=0A@@ -937,9 +937,6 @@ static noinl=
ine_for_stack int ethtool_get_rxnfc(struct net_device *dev,=0A 			return -E=
INVAL;=0A 	}=0A =0A-	if (info.cmd !=3D cmd)=0A-		return -EINVAL;=0A-=0A 	if=
 (info.cmd =3D=3D ETHTOOL_GRXCLSRLALL) {=0A 		if (info.rule_cnt > 0) {=0A 	=
		if (info.rule_cnt <=3D KMALLOC_MAX_SIZE / sizeof(u32))=0A-- =0A2.30.2=0A=
=0A=0AFrom c8ca4ec51d34b5441b4887f2f6ebdd34bb63b11a Mon Sep 17 00:00:00 200=
1=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr =
2021 20:24:26 +0100=0ASubject: [PATCH 101/151] Revert "media: isif: fix a N=
ULL pointer dereference=0A bug"=0A=0AThis reverts commit a26ac6c1bed951b206=
6cc4b2257facd919e35c0b.=0A=0ACommits from @umn.edu addresses have been foun=
d to be submitted in "bad=0Afaith" to try to test the kernel community's ab=
ility to review "known=0Amalicious" changes.  The result of these submissio=
ns can be found in a=0Apaper published at the 42nd IEEE Symposium on Securi=
ty and Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=
=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu (University=
=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of =
this, all submissions from this group must be reverted from=0Athe kernel tr=
ee and will need to be re-reviewed again to determine if=0Athey actually ar=
e a valid fix.  Until that work is complete, remove this=0Achange to ensure=
 that no problems are being introduced into the=0Acodebase.=0A=0ASigned-off=
-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/media/pl=
atform/davinci/isif.c | 3 +--=0A 1 file changed, 1 insertion(+), 2 deletion=
s(-)=0A=0Adiff --git a/drivers/media/platform/davinci/isif.c b/drivers/medi=
a/platform/davinci/isif.c=0Aindex e2e7ab7b7f45..139ec3cd6643 100644=0A--- a=
/drivers/media/platform/davinci/isif.c=0A+++ b/drivers/media/platform/davin=
ci/isif.c=0A@@ -1082,8 +1082,7 @@ static int isif_probe(struct platform_dev=
ice *pdev)=0A =0A 	while (i >=3D 0) {=0A 		res =3D platform_get_resource(pd=
ev, IORESOURCE_MEM, i);=0A-		if (res)=0A-			release_mem_region(res->start, =
resource_size(res));=0A+		release_mem_region(res->start, resource_size(res)=
);=0A 		i--;=0A 	}=0A 	vpfe_unregister_ccdc_device(&isif_hw_dev);=0A-- =0A2=
=2E30.2=0A=0A=0AFrom 35ea8fe7c04db8e93e999ec0a1ea07aa9bd05111 Mon Sep 17 00=
:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: We=
d, 21 Apr 2021 20:24:27 +0100=0ASubject: [PATCH 102/151] Revert "scsi: 3w-x=
xxx: fix a missing-check bug"=0A=0AThis reverts commit 9899e4d3523faaef17c6=
7141aa80ff2088f17871.=0A=0ACommits from @umn.edu addresses have been found =
to be submitted in "bad=0Afaith" to try to test the kernel community's abil=
ity to review "known=0Amalicious" changes.  The result of these submissions=
 can be found in a=0Apaper published at the 42nd IEEE Symposium on Security=
 and Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0A=
Vulnerabilities via Hypocrite Commits" written by Qiushi Wu (University=0Ao=
f Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this=
, all submissions from this group must be reverted from=0Athe kernel tree a=
nd will need to be re-reviewed again to determine if=0Athey actually are a =
valid fix.  Until that work is complete, remove this=0Achange to ensure tha=
t no problems are being introduced into the=0Acodebase.=0A=0ASigned-off-by:=
 Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/scsi/3w-xxxx=
=2Ec | 3 ---=0A 1 file changed, 3 deletions(-)=0A=0Adiff --git a/drivers/sc=
si/3w-xxxx.c b/drivers/scsi/3w-xxxx.c=0Aindex 2b1e0d503020..cb1f98a894f1 10=
0644=0A--- a/drivers/scsi/3w-xxxx.c=0A+++ b/drivers/scsi/3w-xxxx.c=0A@@ -10=
35,9 +1035,6 @@ static int tw_chrdev_open(struct inode *inode, struct file =
*file)=0A =0A 	dprintk(KERN_WARNING "3w-xxxx: tw_ioctl_open()\n");=0A =0A-	=
if (!capable(CAP_SYS_ADMIN))=0A-		return -EACCES;=0A-=0A 	minor_number =3D =
iminor(inode);=0A 	if (minor_number >=3D tw_device_extension_count)=0A 		re=
turn -ENODEV;=0A-- =0A2.30.2=0A=0A=0AFrom 51018ba33c69cff4de95c696b29c97906=
5c936c1 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@=
gmail.com>=0ADate: Wed, 21 Apr 2021 20:24:27 +0100=0ASubject: [PATCH 103/15=
1] Revert "scsi: 3w-9xxx: fix a missing-check bug"=0A=0AThis reverts commit=
 c9318a3e0218bc9dacc25be46b9eec363259536f.=0A=0ACommits from @umn.edu addre=
sses have been found to be submitted in "bad=0Afaith" to try to test the ke=
rnel community's ability to review "known=0Amalicious" changes.  The result=
 of these submissions can be found in a=0Apaper published at the 42nd IEEE =
Symposium on Security and Privacy=0Aentitled, "Open Source Insecurity: Stea=
lthily Introducing=0AVulnerabilities via Hypocrite Commits" written by Qius=
hi Wu (University=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=
=0A=0ABecause of this, all submissions from this group must be reverted fro=
m=0Athe kernel tree and will need to be re-reviewed again to determine if=
=0Athey actually are a valid fix.  Until that work is complete, remove this=
=0Achange to ensure that no problems are being introduced into the=0Acodeba=
se.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=
=0A drivers/scsi/3w-9xxx.c | 5 -----=0A 1 file changed, 5 deletions(-)=0A=
=0Adiff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c=0Aindex 333=
7b1e80412..005f968fea42 100644=0A--- a/drivers/scsi/3w-9xxx.c=0A+++ b/drive=
rs/scsi/3w-9xxx.c=0A@@ -886,11 +886,6 @@ static int twa_chrdev_open(struct =
inode *inode, struct file *file)=0A 	unsigned int minor_number;=0A 	int ret=
val =3D TW_IOCTL_ERROR_OS_ENODEV;=0A =0A-	if (!capable(CAP_SYS_ADMIN)) {=0A=
-		retval =3D -EACCES;=0A-		goto out;=0A-	}=0A-=0A 	minor_number =3D iminor=
(inode);=0A 	if (minor_number >=3D twa_device_extension_count)=0A 		goto ou=
t;=0A-- =0A2.30.2=0A=0A=0AFrom d2753e64b13bd3e72ad699141d32306d44a49640 Mon=
 Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=
=0ADate: Wed, 21 Apr 2021 20:24:28 +0100=0ASubject: [PATCH 104/151] Revert =
"ethtool: fix a potential missing-check bug"=0A=0AThis reverts commit d656f=
e49e33df48ee6bc19e871f5862f49895c9e.=0A=0ACommits from @umn.edu addresses h=
ave been found to be submitted in "bad=0Afaith" to try to test the kernel c=
ommunity's ability to review "known=0Amalicious" changes.  The result of th=
ese submissions can be found in a=0Apaper published at the 42nd IEEE Sympos=
ium on Security and Privacy=0Aentitled, "Open Source Insecurity: Stealthily=
 Introducing=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu =
(University=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=0A=
Because of this, all submissions from this group must be reverted from=0Ath=
e kernel tree and will need to be re-reviewed again to determine if=0Athey =
actually are a valid fix.  Until that work is complete, remove this=0Achang=
e to ensure that no problems are being introduced into the=0Acodebase.=0A=
=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A net=
/core/ethtool.c | 5 -----=0A 1 file changed, 5 deletions(-)=0A=0Adiff --git=
 a/net/core/ethtool.c b/net/core/ethtool.c=0Aindex 606bb30b98cf..37c3622290=
a4 100644=0A--- a/net/core/ethtool.c=0A+++ b/net/core/ethtool.c=0A@@ -930,1=
1 +930,6 @@ static noinline_for_stack int ethtool_get_rxnfc(struct net_devi=
ce *dev,=0A 		info_size =3D sizeof(info);=0A 		if (copy_from_user(&info, us=
eraddr, info_size))=0A 			return -EFAULT;=0A-		/* Since malicious users may=
 modify the original data,=0A-		 * we need to check whether FLOW_RSS is sti=
ll requested.=0A-		 */=0A-		if (!(info.flow_type & FLOW_RSS))=0A-			return =
-EINVAL;=0A 	}=0A =0A 	if (info.cmd =3D=3D ETHTOOL_GRXCLSRLALL) {=0A-- =0A2=
=2E30.2=0A=0A=0AFrom 0ba71f594b642f15ae275e37a28da803fd841dc6 Mon Sep 17 00=
:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: We=
d, 21 Apr 2021 20:24:28 +0100=0ASubject: [PATCH 105/151] Revert "dm ioctl: =
harden copy_params()'s=0A copy_from_user() from malicious users"=0A=0AThis =
reverts commit 800a7340ab7dd667edf95e74d8e4f23a17e87076.=0A=0ACommits from =
@umn.edu addresses have been found to be submitted in "bad=0Afaith" to try =
to test the kernel community's ability to review "known=0Amalicious" change=
s.  The result of these submissions can be found in a=0Apaper published at =
the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Open Source In=
security: Stealthily Introducing=0AVulnerabilities via Hypocrite Commits" w=
ritten by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (University =
of Minnesota).=0A=0ABecause of this, all submissions from this group must b=
e reverted from=0Athe kernel tree and will need to be re-reviewed again to =
determine if=0Athey actually are a valid fix.  Until that work is complete,=
 remove this=0Achange to ensure that no problems are being introduced into =
the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail=
=2Ecom>=0A---=0A drivers/md/dm-ioctl.c | 18 ++++++++++++------=0A 1 file ch=
anged, 12 insertions(+), 6 deletions(-)=0A=0Adiff --git a/drivers/md/dm-ioc=
tl.c b/drivers/md/dm-ioctl.c=0Aindex 3f15d8dc2b71..16107f1d8287 100644=0A--=
- a/drivers/md/dm-ioctl.c=0A+++ b/drivers/md/dm-ioctl.c=0A@@ -1747,7 +1747,=
8 @@ static void free_params(struct dm_ioctl *param, size_t param_size, int=
 param_fla=0A }=0A =0A static int copy_params(struct dm_ioctl __user *user,=
 struct dm_ioctl *param_kernel,=0A-		       int ioctl_flags, struct dm_ioct=
l **param, int *param_flags)=0A+		       int ioctl_flags,=0A+		       struc=
t dm_ioctl **param, int *param_flags)=0A {=0A 	struct dm_ioctl *dmi;=0A 	in=
t secure_data;=0A@@ -1788,13 +1789,18 @@ static int copy_params(struct dm_i=
octl __user *user, struct dm_ioctl *param_kern=0A =0A 	*param_flags |=3D DM=
_PARAMS_MALLOC;=0A =0A-	/* Copy from param_kernel (which was already copied=
 from user) */=0A-	memcpy(dmi, param_kernel, minimum_data_size);=0A-=0A-	if=
 (copy_from_user(&dmi->data, (char __user *)user + minimum_data_size,=0A-		=
	   param_kernel->data_size - minimum_data_size))=0A+	if (copy_from_user(dm=
i, user, param_kernel->data_size))=0A 		goto bad;=0A+=0A data_copied:=0A+	/=
*=0A+	 * Abort if something changed the ioctl data while it was being copie=
d.=0A+	 */=0A+	if (dmi->data_size !=3D param_kernel->data_size) {=0A+		DMER=
R("rejecting ioctl: data size modified while processing parameters");=0A+		=
goto bad;=0A+	}=0A+=0A 	/* Wipe the user buffer so we do not return it to u=
serspace */=0A 	if (secure_data && clear_user(user, param_kernel->data_size=
))=0A 		goto bad;=0A-- =0A2.30.2=0A=0A=0AFrom 0a1d2f4317ac8da67d829ca9d4461=
8fbcb3b9245 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukher=
jee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:26:21 +0100=0ASubject: [PATCH 10=
6/151] Revert "media: sti: Fix reference count leaks"=0A=0AThis reverts com=
mit 62f3bc07008d7c1994422771ac06d7690949762f.=0A=0ACommits from @umn.edu ad=
dresses have been found to be submitted in "bad=0Afaith" to try to test the=
 kernel community's ability to review "known=0Amalicious" changes.  The res=
ult of these submissions can be found in a=0Apaper published at the 42nd IE=
EE Symposium on Security and Privacy=0Aentitled, "Open Source Insecurity: S=
tealthily Introducing=0AVulnerabilities via Hypocrite Commits" written by Q=
iushi Wu (University=0Aof Minnesota) and Kangjie Lu (University of Minnesot=
a).=0A=0ABecause of this, all submissions from this group must be reverted =
=66rom=0Athe kernel tree and will need to be re-reviewed again to determine=
 if=0Athey actually are a valid fix.  Until that work is complete, remove t=
his=0Achange to ensure that no problems are being introduced into the=0Acod=
ebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A-=
--=0A drivers/media/platform/sti/hva/hva-hw.c | 2 --=0A 1 file changed, 2 d=
eletions(-)=0A=0Adiff --git a/drivers/media/platform/sti/hva/hva-hw.c b/dri=
vers/media/platform/sti/hva/hva-hw.c=0Aindex 43f279e2a6a3..8533d3bc6d5c 100=
644=0A--- a/drivers/media/platform/sti/hva/hva-hw.c=0A+++ b/drivers/media/p=
latform/sti/hva/hva-hw.c=0A@@ -272,7 +272,6 @@ static unsigned long int hva=
_hw_get_ip_version(struct hva_dev *hva)=0A =0A 	if (pm_runtime_get_sync(dev=
) < 0) {=0A 		dev_err(dev, "%s     failed to get pm_runtime\n", HVA_PREFIX)=
;=0A-		pm_runtime_put_noidle(dev);=0A 		mutex_unlock(&hva->protect_mutex);=
=0A 		return -EFAULT;=0A 	}=0A@@ -554,7 +553,6 @@ void hva_hw_dump_regs(str=
uct hva_dev *hva, struct seq_file *s)=0A =0A 	if (pm_runtime_get_sync(dev) =
< 0) {=0A 		seq_puts(s, "Cannot wake up IP\n");=0A-		pm_runtime_put_noidle(=
dev);=0A 		mutex_unlock(&hva->protect_mutex);=0A 		return;=0A 	}=0A-- =0A2.=
30.2=0A=0A=0AFrom 42aa5f7cbb3ae29c800f1a33c5a030a91e864a22 Mon Sep 17 00:00=
:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, =
21 Apr 2021 20:26:21 +0100=0ASubject: [PATCH 107/151] Revert "media: rockch=
ip/rga: Fix a reference count=0A leak."=0A=0AThis reverts commit 4e954d4dea=
1e0df3bc727af1dc316ebafc9c36f7.=0A=0ACommits from @umn.edu addresses have b=
een found to be submitted in "bad=0Afaith" to try to test the kernel commun=
ity's ability to review "known=0Amalicious" changes.  The result of these s=
ubmissions can be found in a=0Apaper published at the 42nd IEEE Symposium o=
n Security and Privacy=0Aentitled, "Open Source Insecurity: Stealthily Intr=
oducing=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu (Univ=
ersity=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecau=
se of this, all submissions from this group must be reverted from=0Athe ker=
nel tree and will need to be re-reviewed again to determine if=0Athey actua=
lly are a valid fix.  Until that work is complete, remove this=0Achange to =
ensure that no problems are being introduced into the=0Acodebase.=0A=0ASign=
ed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/me=
dia/platform/rockchip/rga/rga-buf.c | 1 -=0A 1 file changed, 1 deletion(-)=
=0A=0Adiff --git a/drivers/media/platform/rockchip/rga/rga-buf.c b/drivers/=
media/platform/rockchip/rga/rga-buf.c=0Aindex bf9a75b75083..36b821ccc1db 10=
0644=0A--- a/drivers/media/platform/rockchip/rga/rga-buf.c=0A+++ b/drivers/=
media/platform/rockchip/rga/rga-buf.c=0A@@ -81,7 +81,6 @@ static int rga_bu=
f_start_streaming(struct vb2_queue *q, unsigned int count)=0A =0A 	ret =3D =
pm_runtime_get_sync(rga->dev);=0A 	if (ret < 0) {=0A-		pm_runtime_put_noidl=
e(rga->dev);=0A 		rga_buf_return_buffers(q, VB2_BUF_STATE_QUEUED);=0A 		ret=
urn ret;=0A 	}=0A-- =0A2.30.2=0A=0A=0AFrom 8e68e03d4c01de9bc7ec76ae66d5dbf4=
4b151ee9 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee=
@gmail.com>=0ADate: Wed, 21 Apr 2021 20:26:22 +0100=0ASubject: [PATCH 108/1=
51] Revert "media: rcar-vin: Fix a reference count leak."=0A=0AThis reverts=
 commit aa60f4ad0707daba0dbfc1d8729a46c47c07562c.=0A=0ACommits from @umn.ed=
u addresses have been found to be submitted in "bad=0Afaith" to try to test=
 the kernel community's ability to review "known=0Amalicious" changes.  The=
 result of these submissions can be found in a=0Apaper published at the 42n=
d IEEE Symposium on Security and Privacy=0Aentitled, "Open Source Insecurit=
y: Stealthily Introducing=0AVulnerabilities via Hypocrite Commits" written =
by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (University of Minn=
esota).=0A=0ABecause of this, all submissions from this group must be rever=
ted from=0Athe kernel tree and will need to be re-reviewed again to determi=
ne if=0Athey actually are a valid fix.  Until that work is complete, remove=
 this=0Achange to ensure that no problems are being introduced into the=0Ac=
odebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=
=0A---=0A drivers/media/platform/rcar-vin/rcar-dma.c | 4 +---=0A 1 file cha=
nged, 1 insertion(+), 3 deletions(-)=0A=0Adiff --git a/drivers/media/platfo=
rm/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c=0Aindex=
 e5f636080108..3cb29b2e0b2b 100644=0A--- a/drivers/media/platform/rcar-vin/=
rcar-dma.c=0A+++ b/drivers/media/platform/rcar-vin/rcar-dma.c=0A@@ -1334,10=
 +1334,8 @@ int rvin_set_channel_routing(struct rvin_dev *vin, u8 chsel)=0A=
 	int ret;=0A =0A 	ret =3D pm_runtime_get_sync(vin->dev);=0A-	if (ret < 0) =
{=0A-		pm_runtime_put_noidle(vin->dev);=0A+	if (ret < 0)=0A 		return ret;=
=0A-	}=0A =0A 	/* Make register writes take effect immediately. */=0A 	vnmc=
 =3D rvin_read(vin, VNMC_REG);=0A-- =0A2.30.2=0A=0A=0AFrom 4cff48df1f4de935=
1a4de39c93cc2bd75796e704 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <=
sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:26:22 +0100=0ASubje=
ct: [PATCH 109/151] Revert "firmware: Fix a reference count leak."=0A=0AThi=
s reverts commit 83ea63708a298d8cb7ccffae83e400ec95f9156b.=0A=0ACommits fro=
m @umn.edu addresses have been found to be submitted in "bad=0Afaith" to tr=
y to test the kernel community's ability to review "known=0Amalicious" chan=
ges.  The result of these submissions can be found in a=0Apaper published a=
t the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Open Source =
Insecurity: Stealthily Introducing=0AVulnerabilities via Hypocrite Commits"=
 written by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (Universit=
y of Minnesota).=0A=0ABecause of this, all submissions from this group must=
 be reverted from=0Athe kernel tree and will need to be re-reviewed again t=
o determine if=0Athey actually are a valid fix.  Until that work is complet=
e, remove this=0Achange to ensure that no problems are being introduced int=
o the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gma=
il.com>=0A---=0A drivers/firmware/qemu_fw_cfg.c | 7 +++----=0A 1 file chang=
ed, 3 insertions(+), 4 deletions(-)=0A=0Adiff --git a/drivers/firmware/qemu=
_fw_cfg.c b/drivers/firmware/qemu_fw_cfg.c=0Aindex 6945c3c96637..039e0f91db=
a8 100644=0A--- a/drivers/firmware/qemu_fw_cfg.c=0A+++ b/drivers/firmware/q=
emu_fw_cfg.c=0A@@ -605,10 +605,8 @@ static int fw_cfg_register_file(const s=
truct fw_cfg_file *f)=0A 	/* register entry under "/sys/firmware/qemu_fw_cf=
g/by_key/" */=0A 	err =3D kobject_init_and_add(&entry->kobj, &fw_cfg_sysfs_=
entry_ktype,=0A 				   fw_cfg_sel_ko, "%d", entry->select);=0A-	if (err) {=
=0A-		kobject_put(&entry->kobj);=0A-		return err;=0A-	}=0A+	if (err)=0A+		g=
oto err_register;=0A =0A 	/* add raw binary content access */=0A 	err =3D s=
ysfs_create_bin_file(&entry->kobj, &fw_cfg_sysfs_attr_raw);=0A@@ -624,6 +62=
2,7 @@ static int fw_cfg_register_file(const struct fw_cfg_file *f)=0A =0A =
err_add_raw:=0A 	kobject_del(&entry->kobj);=0A+err_register:=0A 	kfree(entr=
y);=0A 	return err;=0A }=0A-- =0A2.30.2=0A=0A=0AFrom 4ff1d8662acb743faea7dd=
562334fa292d0900e6 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm=
=2Emukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:26:22 +0100=0ASubject: =
[PATCH 110/151] Revert "drm/nouveau: fix reference count leak in=0A nouveau=
_debugfs_strap_peek"=0A=0AThis reverts commit db0a2e4857dd8a0235091e3c753e3=
56f2291bd56.=0A=0ACommits from @umn.edu addresses have been found to be sub=
mitted in "bad=0Afaith" to try to test the kernel community's ability to re=
view "known=0Amalicious" changes.  The result of these submissions can be f=
ound in a=0Apaper published at the 42nd IEEE Symposium on Security and Priv=
acy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVulnerabi=
lities via Hypocrite Commits" written by Qiushi Wu (University=0Aof Minneso=
ta) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, all sub=
missions from this group must be reverted from=0Athe kernel tree and will n=
eed to be re-reviewed again to determine if=0Athey actually are a valid fix=
=2E  Until that work is complete, remove this=0Achange to ensure that no pr=
oblems are being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip =
Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/gpu/drm/nouveau/nou=
veau_debugfs.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 deletions(-)=
=0A=0Adiff --git a/drivers/gpu/drm/nouveau/nouveau_debugfs.c b/drivers/gpu/=
drm/nouveau/nouveau_debugfs.c=0Aindex 3b13feca970f..d81ff44787aa 100644=0A-=
-- a/drivers/gpu/drm/nouveau/nouveau_debugfs.c=0A+++ b/drivers/gpu/drm/nouv=
eau/nouveau_debugfs.c=0A@@ -54,10 +54,8 @@ nouveau_debugfs_strap_peek(struc=
t seq_file *m, void *data)=0A 	int ret;=0A =0A 	ret =3D pm_runtime_get_sync=
(drm->dev->dev);=0A-	if (ret < 0 && ret !=3D -EACCES) {=0A-		pm_runtime_put=
_autosuspend(drm->dev->dev);=0A+	if (ret < 0 && ret !=3D -EACCES)=0A 		retu=
rn ret;=0A-	}=0A =0A 	seq_printf(m, "0x%08x\n",=0A 		   nvif_rd32(&drm->cli=
ent.device.object, 0x101000));=0A-- =0A2.30.2=0A=0A=0AFrom 5e9afc5486e8da7b=
9b7070c3b22fe46e9da39a73 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <=
sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:26:23 +0100=0ASubje=
ct: [PATCH 111/151] Revert "drm/nouveau: fix reference count leak in=0A nv5=
0_disp_atomic_commit"=0A=0AThis reverts commit 19e81f6325a95f5266cbc57f3302=
d65f7c3aa338.=0A=0ACommits from @umn.edu addresses have been found to be su=
bmitted in "bad=0Afaith" to try to test the kernel community's ability to r=
eview "known=0Amalicious" changes.  The result of these submissions can be =
found in a=0Apaper published at the 42nd IEEE Symposium on Security and Pri=
vacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVulnerab=
ilities via Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnes=
ota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, all su=
bmissions from this group must be reverted from=0Athe kernel tree and will =
need to be re-reviewed again to determine if=0Athey actually are a valid fi=
x.  Until that work is complete, remove this=0Achange to ensure that no pro=
blems are being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip M=
ukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/gpu/drm/nouveau/disp=
nv50/disp.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 deletions(-)=0A=
=0Adiff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/drm/n=
ouveau/dispnv50/disp.c=0Aindex daa79d39201f..6a57f367efed 100644=0A--- a/dr=
ivers/gpu/drm/nouveau/dispnv50/disp.c=0A+++ b/drivers/gpu/drm/nouveau/dispn=
v50/disp.c=0A@@ -2034,10 +2034,8 @@ nv50_disp_atomic_commit(struct drm_devi=
ce *dev,=0A 	int ret, i;=0A =0A 	ret =3D pm_runtime_get_sync(dev->dev);=0A-=
	if (ret < 0 && ret !=3D -EACCES) {=0A-		pm_runtime_put_autosuspend(dev->de=
v);=0A+	if (ret < 0 && ret !=3D -EACCES)=0A 		return ret;=0A-	}=0A =0A 	ret=
 =3D drm_atomic_helper_setup_commit(state, nonblock);=0A 	if (ret)=0A-- =0A=
2.30.2=0A=0A=0AFrom f1771a047f1c80aa43461be256aa92ded7f132f3 Mon Sep 17 00:=
00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed=
, 21 Apr 2021 20:26:23 +0100=0ASubject: [PATCH 112/151] Revert "drm/nouveau=
: fix multiple instances of=0A reference count leaks"=0A=0AThis reverts com=
mit 3b69bcd45426f24e38e2f20ec0f40d0730368c6e.=0A=0ACommits from @umn.edu ad=
dresses have been found to be submitted in "bad=0Afaith" to try to test the=
 kernel community's ability to review "known=0Amalicious" changes.  The res=
ult of these submissions can be found in a=0Apaper published at the 42nd IE=
EE Symposium on Security and Privacy=0Aentitled, "Open Source Insecurity: S=
tealthily Introducing=0AVulnerabilities via Hypocrite Commits" written by Q=
iushi Wu (University=0Aof Minnesota) and Kangjie Lu (University of Minnesot=
a).=0A=0ABecause of this, all submissions from this group must be reverted =
=66rom=0Athe kernel tree and will need to be re-reviewed again to determine=
 if=0Athey actually are a valid fix.  Until that work is complete, remove t=
his=0Achange to ensure that no problems are being introduced into the=0Acod=
ebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A-=
--=0A drivers/gpu/drm/nouveau/nouveau_drm.c | 8 ++------=0A drivers/gpu/drm=
/nouveau/nouveau_gem.c | 4 +---=0A 2 files changed, 3 insertions(+), 9 dele=
tions(-)=0A=0Adiff --git a/drivers/gpu/drm/nouveau/nouveau_drm.c b/drivers/=
gpu/drm/nouveau/nouveau_drm.c=0Aindex 5347e5bdee8c..b1beed40e746 100644=0A-=
-- a/drivers/gpu/drm/nouveau/nouveau_drm.c=0A+++ b/drivers/gpu/drm/nouveau/=
nouveau_drm.c=0A@@ -1052,10 +1052,8 @@ nouveau_drm_open(struct drm_device *=
dev, struct drm_file *fpriv)=0A =0A 	/* need to bring up power immediately =
if opening device */=0A 	ret =3D pm_runtime_get_sync(dev->dev);=0A-	if (ret=
 < 0 && ret !=3D -EACCES) {=0A-		pm_runtime_put_autosuspend(dev->dev);=0A+	=
if (ret < 0 && ret !=3D -EACCES)=0A 		return ret;=0A-	}=0A =0A 	get_task_co=
mm(tmpname, current);=0A 	snprintf(name, sizeof(name), "%s[%d]", tmpname, p=
id_nr(fpriv->pid));=0A@@ -1137,10 +1135,8 @@ nouveau_drm_ioctl(struct file =
*file, unsigned int cmd, unsigned long arg)=0A 	long ret;=0A =0A 	ret =3D p=
m_runtime_get_sync(dev->dev);=0A-	if (ret < 0 && ret !=3D -EACCES) {=0A-		p=
m_runtime_put_autosuspend(dev->dev);=0A+	if (ret < 0 && ret !=3D -EACCES)=
=0A 		return ret;=0A-	}=0A =0A 	switch (_IOC_NR(cmd) - DRM_COMMAND_BASE) {=
=0A 	case DRM_NOUVEAU_NVIF:=0Adiff --git a/drivers/gpu/drm/nouveau/nouveau_=
gem.c b/drivers/gpu/drm/nouveau/nouveau_gem.c=0Aindex 2dd9fcab464b..f004ce0=
19bf6 100644=0A--- a/drivers/gpu/drm/nouveau/nouveau_gem.c=0A+++ b/drivers/=
gpu/drm/nouveau/nouveau_gem.c=0A@@ -45,10 +45,8 @@ nouveau_gem_object_del(s=
truct drm_gem_object *gem)=0A 	int ret;=0A =0A 	ret =3D pm_runtime_get_sync=
(dev);=0A-	if (WARN_ON(ret < 0 && ret !=3D -EACCES)) {=0A-		pm_runtime_put_=
autosuspend(dev);=0A+	if (WARN_ON(ret < 0 && ret !=3D -EACCES))=0A 		return=
;=0A-	}=0A =0A 	if (gem->import_attach)=0A 		drm_prime_gem_destroy(gem, nvb=
o->bo.sg);=0A-- =0A2.30.2=0A=0A=0AFrom 725a570aa6d5c94d9ee1f8ab256fa472925b=
fb5e Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gma=
il.com>=0ADate: Wed, 21 Apr 2021 20:26:23 +0100=0ASubject: [PATCH 113/151] =
Revert "drm/nouveau/drm/noveau: fix reference count=0A leak in nouveau_fbco=
n_open"=0A=0AThis reverts commit d23d52e38cc9c2ae38cf3143af22a8ac821123b5.=
=0A=0ACommits from @umn.edu addresses have been found to be submitted in "b=
ad=0Afaith" to try to test the kernel community's ability to review "known=
=0Amalicious" changes.  The result of these submissions can be found in a=
=0Apaper published at the 42nd IEEE Symposium on Security and Privacy=0Aent=
itled, "Open Source Insecurity: Stealthily Introducing=0AVulnerabilities vi=
a Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnesota) and K=
angjie Lu (University of Minnesota).=0A=0ABecause of this, all submissions =
=66rom this group must be reverted from=0Athe kernel tree and will need to =
be re-reviewed again to determine if=0Athey actually are a valid fix.  Unti=
l that work is complete, remove this=0Achange to ensure that no problems ar=
e being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee=
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/gpu/drm/nouveau/nouveau_fbco=
n.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 deletions(-)=0A=0Adiff --=
git a/drivers/gpu/drm/nouveau/nouveau_fbcon.c b/drivers/gpu/drm/nouveau/nou=
veau_fbcon.c=0Aindex c09ea357e88f..5cf2381f667e 100644=0A--- a/drivers/gpu/=
drm/nouveau/nouveau_fbcon.c=0A+++ b/drivers/gpu/drm/nouveau/nouveau_fbcon.c=
=0A@@ -189,10 +189,8 @@ nouveau_fbcon_open(struct fb_info *info, int user)=
=0A 	struct nouveau_fbdev *fbcon =3D info->par;=0A 	struct nouveau_drm *drm=
 =3D nouveau_drm(fbcon->helper.dev);=0A 	int ret =3D pm_runtime_get_sync(dr=
m->dev->dev);=0A-	if (ret < 0 && ret !=3D -EACCES) {=0A-		pm_runtime_put(dr=
m->dev->dev);=0A+	if (ret < 0 && ret !=3D -EACCES)=0A 		return ret;=0A-	}=
=0A 	return 0;=0A }=0A =0A-- =0A2.30.2=0A=0A=0AFrom 900976fede2114201efeff6=
ec148faa8e652c22f Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.=
mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:26:24 +0100=0ASubject: [PA=
TCH 114/151] Revert "PCI: Fix pci_create_slot() reference count=0A leak"=0A=
=0AThis reverts commit 4410fd0c378eb5c44487056dea43fc1bf8ea601b.=0A=0ACommi=
ts from @umn.edu addresses have been found to be submitted in "bad=0Afaith"=
 to try to test the kernel community's ability to review "known=0Amalicious=
" changes.  The result of these submissions can be found in a=0Apaper publi=
shed at the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Open S=
ource Insecurity: Stealthily Introducing=0AVulnerabilities via Hypocrite Co=
mmits" written by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (Uni=
versity of Minnesota).=0A=0ABecause of this, all submissions from this grou=
p must be reverted from=0Athe kernel tree and will need to be re-reviewed a=
gain to determine if=0Athey actually are a valid fix.  Until that work is c=
omplete, remove this=0Achange to ensure that no problems are being introduc=
ed into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherj=
ee@gmail.com>=0A---=0A drivers/pci/slot.c | 6 ++----=0A 1 file changed, 2 i=
nsertions(+), 4 deletions(-)=0A=0Adiff --git a/drivers/pci/slot.c b/drivers=
/pci/slot.c=0Aindex 1e3ed6ec0a4a..62b7680dbaeb 100644=0A--- a/drivers/pci/s=
lot.c=0A+++ b/drivers/pci/slot.c=0A@@ -304,7 +304,6 @@ struct pci_slot *pci=
_create_slot(struct pci_bus *parent, int slot_nr,=0A 	slot_name =3D make_sl=
ot_name(name);=0A 	if (!slot_name) {=0A 		err =3D -ENOMEM;=0A-		kfree(slot)=
;=0A 		goto err;=0A 	}=0A =0A@@ -313,10 +312,8 @@ struct pci_slot *pci_crea=
te_slot(struct pci_bus *parent, int slot_nr,=0A =0A 	err =3D kobject_init_a=
nd_add(&slot->kobj, &pci_slot_ktype, NULL,=0A 				   "%s", slot_name);=0A-	=
if (err) {=0A-		kobject_put(&slot->kobj);=0A+	if (err)=0A 		goto err;=0A-	}=
=0A =0A 	down_read(&pci_bus_sem);=0A 	list_for_each_entry(dev, &parent->dev=
ices, bus_list)=0A@@ -332,6 +329,7 @@ struct pci_slot *pci_create_slot(stru=
ct pci_bus *parent, int slot_nr,=0A 	mutex_unlock(&pci_slot_mutex);=0A 	ret=
urn slot;=0A err:=0A+	kfree(slot);=0A 	slot =3D ERR_PTR(err);=0A 	goto out;=
=0A }=0A-- =0A2.30.2=0A=0A=0AFrom 3a22deac290f4adce8d8f4d553abf03487cde22c =
Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.co=
m>=0ADate: Wed, 21 Apr 2021 20:26:24 +0100=0ASubject: [PATCH 115/151] Rever=
t "omapfb: fix multiple reference count leaks=0A due to pm_runtime_get_sync=
"=0A=0AThis reverts commit 201838142c521b93e6ac380449697bd68f0cf445.=0A=0AC=
ommits from @umn.edu addresses have been found to be submitted in "bad=0Afa=
ith" to try to test the kernel community's ability to review "known=0Amalic=
ious" changes.  The result of these submissions can be found in a=0Apaper p=
ublished at the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Op=
en Source Insecurity: Stealthily Introducing=0AVulnerabilities via Hypocrit=
e Commits" written by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu =
(University of Minnesota).=0A=0ABecause of this, all submissions from this =
group must be reverted from=0Athe kernel tree and will need to be re-review=
ed again to determine if=0Athey actually are a valid fix.  Until that work =
is complete, remove this=0Achange to ensure that no problems are being intr=
oduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.muk=
herjee@gmail.com>=0A---=0A drivers/video/fbdev/omap2/omapfb/dss/dispc.c | 7=
 ++-----=0A drivers/video/fbdev/omap2/omapfb/dss/dsi.c   | 7 ++-----=0A dri=
vers/video/fbdev/omap2/omapfb/dss/dss.c   | 7 ++-----=0A drivers/video/fbde=
v/omap2/omapfb/dss/hdmi4.c | 5 ++---=0A drivers/video/fbdev/omap2/omapfb/ds=
s/hdmi5.c | 5 ++---=0A drivers/video/fbdev/omap2/omapfb/dss/venc.c  | 7 ++-=
----=0A 6 files changed, 12 insertions(+), 26 deletions(-)=0A=0Adiff --git =
a/drivers/video/fbdev/omap2/omapfb/dss/dispc.c b/drivers/video/fbdev/omap2/=
omapfb/dss/dispc.c=0Aindex 34e8171856e9..376ee5bc3ddc 100644=0A--- a/driver=
s/video/fbdev/omap2/omapfb/dss/dispc.c=0A+++ b/drivers/video/fbdev/omap2/om=
apfb/dss/dispc.c=0A@@ -520,11 +520,8 @@ int dispc_runtime_get(void)=0A 	DSS=
DBG("dispc_runtime_get\n");=0A =0A 	r =3D pm_runtime_get_sync(&dispc.pdev->=
dev);=0A-	if (WARN_ON(r < 0)) {=0A-		pm_runtime_put_sync(&dispc.pdev->dev);=
=0A-		return r;=0A-	}=0A-	return 0;=0A+	WARN_ON(r < 0);=0A+	return r < 0 ? =
r : 0;=0A }=0A EXPORT_SYMBOL(dispc_runtime_get);=0A =0Adiff --git a/drivers=
/video/fbdev/omap2/omapfb/dss/dsi.c b/drivers/video/fbdev/omap2/omapfb/dss/=
dsi.c=0Aindex 6f9c25fec994..d620376216e1 100644=0A--- a/drivers/video/fbdev=
/omap2/omapfb/dss/dsi.c=0A+++ b/drivers/video/fbdev/omap2/omapfb/dss/dsi.c=
=0A@@ -1137,11 +1137,8 @@ static int dsi_runtime_get(struct platform_device=
 *dsidev)=0A 	DSSDBG("dsi_runtime_get\n");=0A =0A 	r =3D pm_runtime_get_syn=
c(&dsi->pdev->dev);=0A-	if (WARN_ON(r < 0)) {=0A-		pm_runtime_put_sync(&dsi=
->pdev->dev);=0A-		return r;=0A-	}=0A-	return 0;=0A+	WARN_ON(r < 0);=0A+	re=
turn r < 0 ? r : 0;=0A }=0A =0A static void dsi_runtime_put(struct platform=
_device *dsidev)=0Adiff --git a/drivers/video/fbdev/omap2/omapfb/dss/dss.c =
b/drivers/video/fbdev/omap2/omapfb/dss/dss.c=0Aindex a6b1c1598040..bfc5c4c5=
a26a 100644=0A--- a/drivers/video/fbdev/omap2/omapfb/dss/dss.c=0A+++ b/driv=
ers/video/fbdev/omap2/omapfb/dss/dss.c=0A@@ -768,11 +768,8 @@ int dss_runti=
me_get(void)=0A 	DSSDBG("dss_runtime_get\n");=0A =0A 	r =3D pm_runtime_get_=
sync(&dss.pdev->dev);=0A-	if (WARN_ON(r < 0)) {=0A-		pm_runtime_put_sync(&d=
ss.pdev->dev);=0A-		return r;=0A-	}=0A-	return 0;=0A+	WARN_ON(r < 0);=0A+	r=
eturn r < 0 ? r : 0;=0A }=0A =0A void dss_runtime_put(void)=0Adiff --git a/=
drivers/video/fbdev/omap2/omapfb/dss/hdmi4.c b/drivers/video/fbdev/omap2/om=
apfb/dss/hdmi4.c=0Aindex 4804aab34298..7060ae56c062 100644=0A--- a/drivers/=
video/fbdev/omap2/omapfb/dss/hdmi4.c=0A+++ b/drivers/video/fbdev/omap2/omap=
fb/dss/hdmi4.c=0A@@ -39,10 +39,9 @@ static int hdmi_runtime_get(void)=0A 	D=
SSDBG("hdmi_runtime_get\n");=0A =0A 	r =3D pm_runtime_get_sync(&hdmi.pdev->=
dev);=0A-	if (WARN_ON(r < 0)) {=0A-		pm_runtime_put_sync(&hdmi.pdev->dev);=
=0A+	WARN_ON(r < 0);=0A+	if (r < 0)=0A 		return r;=0A-	}=0A =0A 	return 0;=
=0A }=0Adiff --git a/drivers/video/fbdev/omap2/omapfb/dss/hdmi5.c b/drivers=
/video/fbdev/omap2/omapfb/dss/hdmi5.c=0Aindex a06b6f1355bd..ac49531e4732 10=
0644=0A--- a/drivers/video/fbdev/omap2/omapfb/dss/hdmi5.c=0A+++ b/drivers/v=
ideo/fbdev/omap2/omapfb/dss/hdmi5.c=0A@@ -43,10 +43,9 @@ static int hdmi_ru=
ntime_get(void)=0A 	DSSDBG("hdmi_runtime_get\n");=0A =0A 	r =3D pm_runtime_=
get_sync(&hdmi.pdev->dev);=0A-	if (WARN_ON(r < 0)) {=0A-		pm_runtime_put_sy=
nc(&hdmi.pdev->dev);=0A+	WARN_ON(r < 0);=0A+	if (r < 0)=0A 		return r;=0A-	=
}=0A =0A 	return 0;=0A }=0Adiff --git a/drivers/video/fbdev/omap2/omapfb/ds=
s/venc.c b/drivers/video/fbdev/omap2/omapfb/dss/venc.c=0Aindex 3717dac3dcc8=
=2E.f81e2a46366d 100644=0A--- a/drivers/video/fbdev/omap2/omapfb/dss/venc.c=
=0A+++ b/drivers/video/fbdev/omap2/omapfb/dss/venc.c=0A@@ -391,11 +391,8 @@=
 static int venc_runtime_get(void)=0A 	DSSDBG("venc_runtime_get\n");=0A =0A=
 	r =3D pm_runtime_get_sync(&venc.pdev->dev);=0A-	if (WARN_ON(r < 0)) {=0A-=
		pm_runtime_put_sync(&venc.pdev->dev);=0A-		return r;=0A-	}=0A-	return 0;=
=0A+	WARN_ON(r < 0);=0A+	return r < 0 ? r : 0;=0A }=0A =0A static void venc=
_runtime_put(void)=0A-- =0A2.30.2=0A=0A=0AFrom 6886a8c5c41800bf1672c57ac5f9=
3fdb1f761ec1 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukhe=
rjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:26:24 +0100=0ASubject: [PATCH 1=
16/151] Revert "media: exynos4-is: Fix several reference=0A count leaks due=
 to pm_runtime_get_sync"=0A=0AThis reverts commit 8babe11e46ba469502c04315a=
c5d023269c17881.=0A=0ACommits from @umn.edu addresses have been found to be=
 submitted in "bad=0Afaith" to try to test the kernel community's ability t=
o review "known=0Amalicious" changes.  The result of these submissions can =
be found in a=0Apaper published at the 42nd IEEE Symposium on Security and =
Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVulne=
rabilities via Hypocrite Commits" written by Qiushi Wu (University=0Aof Min=
nesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, all=
 submissions from this group must be reverted from=0Athe kernel tree and wi=
ll need to be re-reviewed again to determine if=0Athey actually are a valid=
 fix.  Until that work is complete, remove this=0Achange to ensure that no =
problems are being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudi=
p Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/media/platform/ex=
ynos4-is/fimc-isp.c  | 4 +---=0A drivers/media/platform/exynos4-is/fimc-lit=
e.c | 2 +-=0A 2 files changed, 2 insertions(+), 4 deletions(-)=0A=0Adiff --=
git a/drivers/media/platform/exynos4-is/fimc-isp.c b/drivers/media/platform=
/exynos4-is/fimc-isp.c=0Aindex a77c49b18511..cde0d254ec1c 100644=0A--- a/dr=
ivers/media/platform/exynos4-is/fimc-isp.c=0A+++ b/drivers/media/platform/e=
xynos4-is/fimc-isp.c=0A@@ -305,10 +305,8 @@ static int fimc_isp_subdev_s_po=
wer(struct v4l2_subdev *sd, int on)=0A =0A 	if (on) {=0A 		ret =3D pm_runti=
me_get_sync(&is->pdev->dev);=0A-		if (ret < 0) {=0A-			pm_runtime_put(&is->=
pdev->dev);=0A+		if (ret < 0)=0A 			return ret;=0A-		}=0A 		set_bit(IS_ST_P=
WR_ON, &is->state);=0A =0A 		ret =3D fimc_is_start_firmware(is);=0Adiff --g=
it a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform=
/exynos4-is/fimc-lite.c=0Aindex efd06621951c..e87c6a09205b 100644=0A--- a/d=
rivers/media/platform/exynos4-is/fimc-lite.c=0A+++ b/drivers/media/platform=
/exynos4-is/fimc-lite.c=0A@@ -470,7 +470,7 @@ static int fimc_lite_open(str=
uct file *file)=0A 	set_bit(ST_FLITE_IN_USE, &fimc->state);=0A 	ret =3D pm_=
runtime_get_sync(&fimc->pdev->dev);=0A 	if (ret < 0)=0A-		goto err_pm;=0A+	=
	goto unlock;=0A =0A 	ret =3D v4l2_fh_open(file);=0A 	if (ret < 0)=0A-- =0A=
2.30.2=0A=0A=0AFrom 9c2981127672325e5083c18817b39dc2ad390748 Mon Sep 17 00:=
00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed=
, 21 Apr 2021 20:26:24 +0100=0ASubject: [PATCH 117/151] Revert "platform/ch=
rome: cros_ec_ishtp: Fix a=0A double-unlock issue"=0A=0AThis reverts commit=
 ab67471562ad22371819ebb7303b8824bd06496b.=0A=0ACommits from @umn.edu addre=
sses have been found to be submitted in "bad=0Afaith" to try to test the ke=
rnel community's ability to review "known=0Amalicious" changes.  The result=
 of these submissions can be found in a=0Apaper published at the 42nd IEEE =
Symposium on Security and Privacy=0Aentitled, "Open Source Insecurity: Stea=
lthily Introducing=0AVulnerabilities via Hypocrite Commits" written by Qius=
hi Wu (University=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=
=0A=0ABecause of this, all submissions from this group must be reverted fro=
m=0Athe kernel tree and will need to be re-reviewed again to determine if=
=0Athey actually are a valid fix.  Until that work is complete, remove this=
=0Achange to ensure that no problems are being introduced into the=0Acodeba=
se.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=
=0A drivers/platform/chrome/cros_ec_ishtp.c | 4 +---=0A 1 file changed, 1 i=
nsertion(+), 3 deletions(-)=0A=0Adiff --git a/drivers/platform/chrome/cros_=
ec_ishtp.c b/drivers/platform/chrome/cros_ec_ishtp.c=0Aindex ab0662a33b41..=
25ca2c894b4d 100644=0A--- a/drivers/platform/chrome/cros_ec_ishtp.c=0A+++ b=
/drivers/platform/chrome/cros_ec_ishtp.c=0A@@ -645,10 +645,8 @@ static int =
cros_ec_ishtp_probe(struct ishtp_cl_device *cl_device)=0A =0A 	/* Register =
croc_ec_dev mfd */=0A 	rv =3D cros_ec_dev_init(client_data);=0A-	if (rv) {=
=0A-		down_write(&init_lock);=0A+	if (rv)=0A 		goto end_cros_ec_dev_init_er=
ror;=0A-	}=0A =0A 	return 0;=0A =0A-- =0A2.30.2=0A=0A=0AFrom e23c44e9589d33=
d3bde48f72229f25cd529d2db7 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee=
 <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:26:25 +0100=0ASub=
ject: [PATCH 118/151] Revert "usb: dwc3: pci: Fix reference count leak in=
=0A dwc3_pci_resume_work"=0A=0AThis reverts commit b1b252d8d9c599054bea1c50=
1faf14da9dd873fe.=0A=0ACommits from @umn.edu addresses have been found to b=
e submitted in "bad=0Afaith" to try to test the kernel community's ability =
to review "known=0Amalicious" changes.  The result of these submissions can=
 be found in a=0Apaper published at the 42nd IEEE Symposium on Security and=
 Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVuln=
erabilities via Hypocrite Commits" written by Qiushi Wu (University=0Aof Mi=
nnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, al=
l submissions from this group must be reverted from=0Athe kernel tree and w=
ill need to be re-reviewed again to determine if=0Athey actually are a vali=
d fix.  Until that work is complete, remove this=0Achange to ensure that no=
 problems are being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sud=
ip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/usb/dwc3/dwc3-pc=
i.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 deletions(-)=0A=0Adiff --=
git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c=0Aindex 58b=
8801ce881..0e8ab892ce94 100644=0A--- a/drivers/usb/dwc3/dwc3-pci.c=0A+++ b/=
drivers/usb/dwc3/dwc3-pci.c=0A@@ -210,10 +210,8 @@ static void dwc3_pci_res=
ume_work(struct work_struct *work)=0A 	int ret;=0A =0A 	ret =3D pm_runtime_=
get_sync(&dwc3->dev);=0A-	if (ret) {=0A-		pm_runtime_put_sync_autosuspend(&=
dwc3->dev);=0A+	if (ret)=0A 		return;=0A-	}=0A =0A 	pm_runtime_mark_last_bu=
sy(&dwc3->dev);=0A 	pm_runtime_put_sync_autosuspend(&dwc3->dev);=0A-- =0A2.=
30.2=0A=0A=0AFrom 96ff89911f1f4f2edec05c1c2b4b5da055eca49e Mon Sep 17 00:00=
:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, =
21 Apr 2021 20:26:25 +0100=0ASubject: [PATCH 119/151] Revert "ASoC: rockchi=
p: Fix a reference count leak."=0A=0AThis reverts commit 9e89c2d5da87017f15=
f9be3c411023f917cd4e58.=0A=0ACommits from @umn.edu addresses have been foun=
d to be submitted in "bad=0Afaith" to try to test the kernel community's ab=
ility to review "known=0Amalicious" changes.  The result of these submissio=
ns can be found in a=0Apaper published at the 42nd IEEE Symposium on Securi=
ty and Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=
=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu (University=
=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of =
this, all submissions from this group must be reverted from=0Athe kernel tr=
ee and will need to be re-reviewed again to determine if=0Athey actually ar=
e a valid fix.  Until that work is complete, remove this=0Achange to ensure=
 that no problems are being introduced into the=0Acodebase.=0A=0ASigned-off=
-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A sound/soc/rockch=
ip/rockchip_pdm.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 deletions(-=
)=0A=0Adiff --git a/sound/soc/rockchip/rockchip_pdm.c b/sound/soc/rockchip/=
rockchip_pdm.c=0Aindex 1707414cfa92..7cd42fcfcf38 100644=0A--- a/sound/soc/=
rockchip/rockchip_pdm.c=0A+++ b/sound/soc/rockchip/rockchip_pdm.c=0A@@ -590=
,10 +590,8 @@ static int rockchip_pdm_resume(struct device *dev)=0A 	int re=
t;=0A =0A 	ret =3D pm_runtime_get_sync(dev);=0A-	if (ret < 0) {=0A-		pm_run=
time_put(dev);=0A+	if (ret < 0)=0A 		return ret;=0A-	}=0A =0A 	ret =3D regc=
ache_sync(pdm->regmap);=0A =0A-- =0A2.30.2=0A=0A=0AFrom 0a59d40f1abb80e2aa7=
3969737cac45723b6c4fc Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sud=
ipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:26:25 +0100=0ASubject:=
 [PATCH 120/151] Revert "media: exynos4-is: Fix a reference count leak=0A d=
ue to pm_runtime_get_sync"=0A=0AThis reverts commit f36a80bc75127bd87d288ce=
fbd445a6a6c50904e.=0A=0ACommits from @umn.edu addresses have been found to =
be submitted in "bad=0Afaith" to try to test the kernel community's ability=
 to review "known=0Amalicious" changes.  The result of these submissions ca=
n be found in a=0Apaper published at the 42nd IEEE Symposium on Security an=
d Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVul=
nerabilities via Hypocrite Commits" written by Qiushi Wu (University=0Aof M=
innesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, a=
ll submissions from this group must be reverted from=0Athe kernel tree and =
will need to be re-reviewed again to determine if=0Athey actually are a val=
id fix.  Until that work is complete, remove this=0Achange to ensure that n=
o problems are being introduced into the=0Acodebase.=0A=0ASigned-off-by: Su=
dip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/media/platform/=
exynos4-is/media-dev.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 deleti=
ons(-)=0A=0Adiff --git a/drivers/media/platform/exynos4-is/media-dev.c b/dr=
ivers/media/platform/exynos4-is/media-dev.c=0Aindex a07d796f63df..2f90607c3=
797 100644=0A--- a/drivers/media/platform/exynos4-is/media-dev.c=0A+++ b/dr=
ivers/media/platform/exynos4-is/media-dev.c=0A@@ -484,10 +484,8 @@ static i=
nt fimc_md_register_sensor_entities(struct fimc_md *fmd)=0A 		return -ENXIO=
;=0A =0A 	ret =3D pm_runtime_get_sync(fmd->pmf);=0A-	if (ret < 0) {=0A-		pm=
_runtime_put(fmd->pmf);=0A+	if (ret < 0)=0A 		return ret;=0A-	}=0A =0A 	fmd=
->num_sensors =3D 0;=0A =0A-- =0A2.30.2=0A=0A=0AFrom 55ee764d77328fabc4f714=
37d8c22d407c7ded1c Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm=
=2Emukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:26:26 +0100=0ASubject: =
[PATCH 121/151] Revert "media: exynos4-is: Fix a reference count=0A leak"=
=0A=0AThis reverts commit 7db4c3dfee01f5e403c2b97fdeb60506017fd355.=0A=0ACo=
mmits from @umn.edu addresses have been found to be submitted in "bad=0Afai=
th" to try to test the kernel community's ability to review "known=0Amalici=
ous" changes.  The result of these submissions can be found in a=0Apaper pu=
blished at the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Ope=
n Source Insecurity: Stealthily Introducing=0AVulnerabilities via Hypocrite=
 Commits" written by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (=
University of Minnesota).=0A=0ABecause of this, all submissions from this g=
roup must be reverted from=0Athe kernel tree and will need to be re-reviewe=
d again to determine if=0Athey actually are a valid fix.  Until that work i=
s complete, remove this=0Achange to ensure that no problems are being intro=
duced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukh=
erjee@gmail.com>=0A---=0A drivers/media/platform/exynos4-is/mipi-csis.c | 4=
 +---=0A 1 file changed, 1 insertion(+), 3 deletions(-)=0A=0Adiff --git a/d=
rivers/media/platform/exynos4-is/mipi-csis.c b/drivers/media/platform/exyno=
s4-is/mipi-csis.c=0Aindex 1aac167abb17..540151bbf58f 100644=0A--- a/drivers=
/media/platform/exynos4-is/mipi-csis.c=0A+++ b/drivers/media/platform/exyno=
s4-is/mipi-csis.c=0A@@ -510,10 +510,8 @@ static int s5pcsis_s_stream(struct=
 v4l2_subdev *sd, int enable)=0A 	if (enable) {=0A 		s5pcsis_clear_counters=
(state);=0A 		ret =3D pm_runtime_get_sync(&state->pdev->dev);=0A-		if (ret =
&& ret !=3D 1) {=0A-			pm_runtime_put_noidle(&state->pdev->dev);=0A+		if (r=
et && ret !=3D 1)=0A 			return ret;=0A-		}=0A 	}=0A =0A 	mutex_lock(&state-=
>lock);=0A-- =0A2.30.2=0A=0A=0AFrom d7cb5708f49e36f9b3be6b2de7089ed74fe847a=
e Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.=
com>=0ADate: Wed, 21 Apr 2021 20:26:26 +0100=0ASubject: [PATCH 122/151] Rev=
ert "media: ti-vpe: Fix a missing check and=0A reference count leak"=0A=0AT=
his reverts commit cd68531d29815c760006fb40f7562599bef3303d.=0A=0ACommits f=
rom @umn.edu addresses have been found to be submitted in "bad=0Afaith" to =
try to test the kernel community's ability to review "known=0Amalicious" ch=
anges.  The result of these submissions can be found in a=0Apaper published=
 at the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Open Sourc=
e Insecurity: Stealthily Introducing=0AVulnerabilities via Hypocrite Commit=
s" written by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (Univers=
ity of Minnesota).=0A=0ABecause of this, all submissions from this group mu=
st be reverted from=0Athe kernel tree and will need to be re-reviewed again=
 to determine if=0Athey actually are a valid fix.  Until that work is compl=
ete, remove this=0Achange to ensure that no problems are being introduced i=
nto the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@g=
mail.com>=0A---=0A drivers/media/platform/ti-vpe/vpe.c | 2 --=0A 1 file cha=
nged, 2 deletions(-)=0A=0Adiff --git a/drivers/media/platform/ti-vpe/vpe.c =
b/drivers/media/platform/ti-vpe/vpe.c=0Aindex 817bd13370ef..8b14ba4a3d9e 10=
0644=0A--- a/drivers/media/platform/ti-vpe/vpe.c=0A+++ b/drivers/media/plat=
form/ti-vpe/vpe.c=0A@@ -2435,8 +2435,6 @@ static int vpe_runtime_get(struct=
 platform_device *pdev)=0A =0A 	r =3D pm_runtime_get_sync(&pdev->dev);=0A 	=
WARN_ON(r < 0);=0A-	if (r)=0A-		pm_runtime_put_noidle(&pdev->dev);=0A 	retu=
rn r < 0 ? r : 0;=0A }=0A =0A-- =0A2.30.2=0A=0A=0AFrom 6358d272834a81932524=
663149793333632d7615 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudi=
pm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:26:26 +0100=0ASubject: =
[PATCH 123/151] Revert "media: stm32-dcmi: Fix a reference count=0A leak"=
=0A=0AThis reverts commit 5c4ffc07f92ef6a2aea4b0a860f13871832d8a6b.=0A=0ACo=
mmits from @umn.edu addresses have been found to be submitted in "bad=0Afai=
th" to try to test the kernel community's ability to review "known=0Amalici=
ous" changes.  The result of these submissions can be found in a=0Apaper pu=
blished at the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Ope=
n Source Insecurity: Stealthily Introducing=0AVulnerabilities via Hypocrite=
 Commits" written by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (=
University of Minnesota).=0A=0ABecause of this, all submissions from this g=
roup must be reverted from=0Athe kernel tree and will need to be re-reviewe=
d again to determine if=0Athey actually are a valid fix.  Until that work i=
s complete, remove this=0Achange to ensure that no problems are being intro=
duced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukh=
erjee@gmail.com>=0A---=0A drivers/media/platform/stm32/stm32-dcmi.c | 4 +++=
-=0A 1 file changed, 3 insertions(+), 1 deletion(-)=0A=0Adiff --git a/drive=
rs/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-d=
cmi.c=0Aindex d41475f56ab5..9392e3409fba 100644=0A--- a/drivers/media/platf=
orm/stm32/stm32-dcmi.c=0A+++ b/drivers/media/platform/stm32/stm32-dcmi.c=0A=
@@ -733,7 +733,7 @@ static int dcmi_start_streaming(struct vb2_queue *vq, u=
nsigned int count)=0A 	if (ret < 0) {=0A 		dev_err(dcmi->dev, "%s: Failed t=
o start streaming, cannot get sync (%d)\n",=0A 			__func__, ret);=0A-		goto=
 err_pm_put;=0A+		goto err_release_buffers;=0A 	}=0A =0A 	ret =3D media_pip=
eline_start(&dcmi->vdev->entity, &dcmi->pipeline);=0A@@ -837,6 +837,8 @@ st=
atic int dcmi_start_streaming(struct vb2_queue *vq, unsigned int count)=0A =
=0A err_pm_put:=0A 	pm_runtime_put(dcmi->dev);=0A+=0A+err_release_buffers:=
=0A 	spin_lock_irq(&dcmi->irqlock);=0A 	/*=0A 	 * Return all buffers to vb2=
 in QUEUED state.=0A-- =0A2.30.2=0A=0A=0AFrom 084c2ea5a3a298edfdd778b65b8d5=
4c7bff764e2 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukher=
jee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:26:26 +0100=0ASubject: [PATCH 12=
4/151] Revert "media: s5p-mfc: Fix a reference count leak"=0A=0AThis revert=
s commit a05590cc08e37b9a09f479169fb179bed248432e.=0A=0ACommits from @umn.e=
du addresses have been found to be submitted in "bad=0Afaith" to try to tes=
t the kernel community's ability to review "known=0Amalicious" changes.  Th=
e result of these submissions can be found in a=0Apaper published at the 42=
nd IEEE Symposium on Security and Privacy=0Aentitled, "Open Source Insecuri=
ty: Stealthily Introducing=0AVulnerabilities via Hypocrite Commits" written=
 by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (University of Min=
nesota).=0A=0ABecause of this, all submissions from this group must be reve=
rted from=0Athe kernel tree and will need to be re-reviewed again to determ=
ine if=0Athey actually are a valid fix.  Until that work is complete, remov=
e this=0Achange to ensure that no problems are being introduced into the=0A=
codebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=
=0A---=0A drivers/media/platform/s5p-mfc/s5p_mfc_pm.c | 4 +---=0A 1 file ch=
anged, 1 insertion(+), 3 deletions(-)=0A=0Adiff --git a/drivers/media/platf=
orm/s5p-mfc/s5p_mfc_pm.c b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c=0Ain=
dex 62d2320a7218..7d52431c2c83 100644=0A--- a/drivers/media/platform/s5p-mf=
c/s5p_mfc_pm.c=0A+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c=0A@@ -79=
,10 +79,8 @@ int s5p_mfc_power_on(void)=0A 	int i, ret =3D 0;=0A =0A 	ret =
=3D pm_runtime_get_sync(pm->device);=0A-	if (ret < 0) {=0A-		pm_runtime_put=
_noidle(pm->device);=0A+	if (ret < 0)=0A 		return ret;=0A-	}=0A =0A 	/* clo=
ck control */=0A 	for (i =3D 0; i < pm->num_clocks; i++) {=0A-- =0A2.30.2=
=0A=0A=0AFrom 02522afe1c2c6b4290bf9f75aec83f457f04496b Mon Sep 17 00:00:00 =
2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 A=
pr 2021 20:26:27 +0100=0ASubject: [PATCH 125/151] Revert "media: platform: =
fcp: Fix a reference count=0A leak."=0A=0AThis reverts commit 28b21e02dce92=
3eff04f168c745898960961d400.=0A=0ACommits from @umn.edu addresses have been=
 found to be submitted in "bad=0Afaith" to try to test the kernel community=
's ability to review "known=0Amalicious" changes.  The result of these subm=
issions can be found in a=0Apaper published at the 42nd IEEE Symposium on S=
ecurity and Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introdu=
cing=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu (Univers=
ity=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause =
of this, all submissions from this group must be reverted from=0Athe kernel=
 tree and will need to be re-reviewed again to determine if=0Athey actually=
 are a valid fix.  Until that work is complete, remove this=0Achange to ens=
ure that no problems are being introduced into the=0Acodebase.=0A=0ASigned-=
off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/media=
/platform/rcar-fcp.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 deletion=
s(-)=0A=0Adiff --git a/drivers/media/platform/rcar-fcp.c b/drivers/media/pl=
atform/rcar-fcp.c=0Aindex 05c712e00a2a..5c6b00737fe7 100644=0A--- a/drivers=
/media/platform/rcar-fcp.c=0A+++ b/drivers/media/platform/rcar-fcp.c=0A@@ -=
103,10 +103,8 @@ int rcar_fcp_enable(struct rcar_fcp_device *fcp)=0A 		retu=
rn 0;=0A =0A 	ret =3D pm_runtime_get_sync(fcp->dev);=0A-	if (ret < 0) {=0A-=
		pm_runtime_put_noidle(fcp->dev);=0A+	if (ret < 0)=0A 		return ret;=0A-	}=
=0A =0A 	return 0;=0A }=0A-- =0A2.30.2=0A=0A=0AFrom 827f555d86fff6eca45f8dc=
cb1f3960f68f07f8b Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.=
mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:26:27 +0100=0ASubject: [PA=
TCH 126/151] Revert "media: st-delta: Fix reference count leak in=0A delta_=
run_work"=0A=0AThis reverts commit e4d4abe6e86f4c09075fea15ed6e8e010babd698=
=2E=0A=0ACommits from @umn.edu addresses have been found to be submitted in=
 "bad=0Afaith" to try to test the kernel community's ability to review "kno=
wn=0Amalicious" changes.  The result of these submissions can be found in a=
=0Apaper published at the 42nd IEEE Symposium on Security and Privacy=0Aent=
itled, "Open Source Insecurity: Stealthily Introducing=0AVulnerabilities vi=
a Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnesota) and K=
angjie Lu (University of Minnesota).=0A=0ABecause of this, all submissions =
=66rom this group must be reverted from=0Athe kernel tree and will need to =
be re-reviewed again to determine if=0Athey actually are a valid fix.  Unti=
l that work is complete, remove this=0Achange to ensure that no problems ar=
e being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee=
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/media/platform/sti/delta/del=
ta-v4l2.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 deletions(-)=0A=0Ad=
iff --git a/drivers/media/platform/sti/delta/delta-v4l2.c b/drivers/media/p=
latform/sti/delta/delta-v4l2.c=0Aindex 2791107e641b..91369fb3ffaa 100644=0A=
--- a/drivers/media/platform/sti/delta/delta-v4l2.c=0A+++ b/drivers/media/p=
latform/sti/delta/delta-v4l2.c=0A@@ -954,10 +954,8 @@ static void delta_run=
_work(struct work_struct *work)=0A 	/* enable the hardware */=0A 	if (!dec-=
>pm) {=0A 		ret =3D delta_get_sync(ctx);=0A-		if (ret) {=0A-			delta_put_au=
tosuspend(ctx);=0A+		if (ret)=0A 			goto err;=0A-		}=0A 	}=0A =0A 	/* decod=
e this access unit */=0A-- =0A2.30.2=0A=0A=0AFrom 0a4ce3cbf5d68e33757e97fdc=
a1e3391e885cc32 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mu=
kherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:26:27 +0100=0ASubject: [PATC=
H 127/151] Revert "ASoC: tegra: Fix reference count leaks."=0A=0AThis rever=
ts commit fd5908860a17f48fac71d08fe65b5954851bcdea.=0A=0ACommits from @umn.=
edu addresses have been found to be submitted in "bad=0Afaith" to try to te=
st the kernel community's ability to review "known=0Amalicious" changes.  T=
he result of these submissions can be found in a=0Apaper published at the 4=
2nd IEEE Symposium on Security and Privacy=0Aentitled, "Open Source Insecur=
ity: Stealthily Introducing=0AVulnerabilities via Hypocrite Commits" writte=
n by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (University of Mi=
nnesota).=0A=0ABecause of this, all submissions from this group must be rev=
erted from=0Athe kernel tree and will need to be re-reviewed again to deter=
mine if=0Athey actually are a valid fix.  Until that work is complete, remo=
ve this=0Achange to ensure that no problems are being introduced into the=
=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.co=
m>=0A---=0A sound/soc/tegra/tegra30_ahub.c | 4 +---=0A sound/soc/tegra/tegr=
a30_i2s.c  | 4 +---=0A 2 files changed, 2 insertions(+), 6 deletions(-)=0A=
=0Adiff --git a/sound/soc/tegra/tegra30_ahub.c b/sound/soc/tegra/tegra30_ah=
ub.c=0Aindex 156e3b9d613c..635eacbd28d4 100644=0A--- a/sound/soc/tegra/tegr=
a30_ahub.c=0A+++ b/sound/soc/tegra/tegra30_ahub.c=0A@@ -643,10 +643,8 @@ st=
atic int tegra30_ahub_resume(struct device *dev)=0A 	int ret;=0A =0A 	ret =
=3D pm_runtime_get_sync(dev);=0A-	if (ret < 0) {=0A-		pm_runtime_put(dev);=
=0A+	if (ret < 0)=0A 		return ret;=0A-	}=0A 	ret =3D regcache_sync(ahub->re=
gmap_ahub);=0A 	ret |=3D regcache_sync(ahub->regmap_apbif);=0A 	pm_runtime_=
put(dev);=0Adiff --git a/sound/soc/tegra/tegra30_i2s.c b/sound/soc/tegra/te=
gra30_i2s.c=0Aindex 8894b7c16a01..e6d548fa980b 100644=0A--- a/sound/soc/teg=
ra/tegra30_i2s.c=0A+++ b/sound/soc/tegra/tegra30_i2s.c=0A@@ -538,10 +538,8 =
@@ static int tegra30_i2s_resume(struct device *dev)=0A 	int ret;=0A =0A 	r=
et =3D pm_runtime_get_sync(dev);=0A-	if (ret < 0) {=0A-		pm_runtime_put(dev=
);=0A+	if (ret < 0)=0A 		return ret;=0A-	}=0A 	ret =3D regcache_sync(i2s->r=
egmap);=0A 	pm_runtime_put(dev);=0A =0A-- =0A2.30.2=0A=0A=0AFrom a9cbe210c5=
14b36852e16ddb1f65092411846a5c Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukhe=
rjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:26:28 +0100=
=0ASubject: [PATCH 128/151] Revert "iommu: Fix reference count leak in=0A i=
ommu_group_alloc."=0A=0AThis reverts commit ca788fd797a7f28a83cb1c1047ff31f=
da7665a56.=0A=0ACommits from @umn.edu addresses have been found to be submi=
tted in "bad=0Afaith" to try to test the kernel community's ability to revi=
ew "known=0Amalicious" changes.  The result of these submissions can be fou=
nd in a=0Apaper published at the 42nd IEEE Symposium on Security and Privac=
y=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVulnerabili=
ties via Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnesota=
) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, all submi=
ssions from this group must be reverted from=0Athe kernel tree and will nee=
d to be re-reviewed again to determine if=0Athey actually are a valid fix. =
 Until that work is complete, remove this=0Achange to ensure that no proble=
ms are being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukh=
erjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/iommu/iommu.c | 2 +-=0A=
 1 file changed, 1 insertion(+), 1 deletion(-)=0A=0Adiff --git a/drivers/io=
mmu/iommu.c b/drivers/iommu/iommu.c=0Aindex 9d7232e26ecf..cd3c0ea56657 1006=
44=0A--- a/drivers/iommu/iommu.c=0A+++ b/drivers/iommu/iommu.c=0A@@ -492,7 =
+492,7 @@ struct iommu_group *iommu_group_alloc(void)=0A 				   NULL, "%d",=
 group->id);=0A 	if (ret) {=0A 		ida_simple_remove(&iommu_group_ida, group-=
>id);=0A-		kobject_put(&group->kobj);=0A+		kfree(group);=0A 		return ERR_PT=
R(ret);=0A 	}=0A =0A-- =0A2.30.2=0A=0A=0AFrom 467dcd0b8580eb4111983a84a8d8e=
6f1d76ef33e Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukher=
jee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:26:28 +0100=0ASubject: [PATCH 12=
9/151] Revert "ACPI: CPPC: Fix reference count leak in=0A acpi_cppc_process=
or_probe()"=0A=0AThis reverts commit 040b4dcc126946a269a4f5e6b3d632daa8a28b=
90.=0A=0ACommits from @umn.edu addresses have been found to be submitted in=
 "bad=0Afaith" to try to test the kernel community's ability to review "kno=
wn=0Amalicious" changes.  The result of these submissions can be found in a=
=0Apaper published at the 42nd IEEE Symposium on Security and Privacy=0Aent=
itled, "Open Source Insecurity: Stealthily Introducing=0AVulnerabilities vi=
a Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnesota) and K=
angjie Lu (University of Minnesota).=0A=0ABecause of this, all submissions =
=66rom this group must be reverted from=0Athe kernel tree and will need to =
be re-reviewed again to determine if=0Athey actually are a valid fix.  Unti=
l that work is complete, remove this=0Achange to ensure that no problems ar=
e being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee=
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/acpi/cppc_acpi.c | 1 -=0A 1 =
file changed, 1 deletion(-)=0A=0Adiff --git a/drivers/acpi/cppc_acpi.c b/dr=
ivers/acpi/cppc_acpi.c=0Aindex f9b1a2abdbe2..a1a858ad4d18 100644=0A--- a/dr=
ivers/acpi/cppc_acpi.c=0A+++ b/drivers/acpi/cppc_acpi.c=0A@@ -865,7 +865,6 =
@@ int acpi_cppc_processor_probe(struct acpi_processor *pr)=0A 			"acpi_cpp=
c");=0A 	if (ret) {=0A 		per_cpu(cpc_desc_ptr, pr->id) =3D NULL;=0A-		kobje=
ct_put(&cpc_ptr->kobj);=0A 		goto out_free;=0A 	}=0A =0A-- =0A2.30.2=0A=0A=
=0AFrom a4ce0aedb9f11018ce7088679d2053ffeceac07b Mon Sep 17 00:00:00 2001=
=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2=
021 20:26:28 +0100=0ASubject: [PATCH 130/151] Revert "ACPI: sysfs: Fix refe=
rence count leak in=0A acpi_sysfs_add_hotplug_profile()"=0A=0AThis reverts =
commit e4cc99efbeb922bbe4b73ef77ce3aa4f76fe1ad2.=0A=0ACommits from @umn.edu=
 addresses have been found to be submitted in "bad=0Afaith" to try to test =
the kernel community's ability to review "known=0Amalicious" changes.  The =
result of these submissions can be found in a=0Apaper published at the 42nd=
 IEEE Symposium on Security and Privacy=0Aentitled, "Open Source Insecurity=
: Stealthily Introducing=0AVulnerabilities via Hypocrite Commits" written b=
y Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (University of Minne=
sota).=0A=0ABecause of this, all submissions from this group must be revert=
ed from=0Athe kernel tree and will need to be re-reviewed again to determin=
e if=0Athey actually are a valid fix.  Until that work is complete, remove =
this=0Achange to ensure that no problems are being introduced into the=0Aco=
debase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A=
---=0A drivers/acpi/sysfs.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 d=
eletions(-)=0A=0Adiff --git a/drivers/acpi/sysfs.c b/drivers/acpi/sysfs.c=
=0Aindex 76c668c05fa0..d25957dd7a5e 100644=0A--- a/drivers/acpi/sysfs.c=0A+=
++ b/drivers/acpi/sysfs.c=0A@@ -993,10 +993,8 @@ void acpi_sysfs_add_hotplu=
g_profile(struct acpi_hotplug_profile *hotplug,=0A =0A 	error =3D kobject_i=
nit_and_add(&hotplug->kobj,=0A 		&acpi_hotplug_profile_ktype, hotplug_kobj,=
 "%s", name);=0A-	if (error) {=0A-		kobject_put(&hotplug->kobj);=0A+	if (er=
ror)=0A 		goto err_out;=0A-	}=0A =0A 	kobject_uevent(&hotplug->kobj, KOBJ_A=
DD);=0A 	return;=0A-- =0A2.30.2=0A=0A=0AFrom 4a70ed5017cc9c7385a0462270a33f=
feba21fad5 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherj=
ee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:26:28 +0100=0ASubject: [PATCH 131=
/151] Revert "ASoC: fix incomplete error-handling in=0A img_i2s_in_probe."=
=0A=0AThis reverts commit 87b3dca712b4385c98d1641d45d1ada21821071b.=0A=0ACo=
mmits from @umn.edu addresses have been found to be submitted in "bad=0Afai=
th" to try to test the kernel community's ability to review "known=0Amalici=
ous" changes.  The result of these submissions can be found in a=0Apaper pu=
blished at the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Ope=
n Source Insecurity: Stealthily Introducing=0AVulnerabilities via Hypocrite=
 Commits" written by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (=
University of Minnesota).=0A=0ABecause of this, all submissions from this g=
roup must be reverted from=0Athe kernel tree and will need to be re-reviewe=
d again to determine if=0Athey actually are a valid fix.  Until that work i=
s complete, remove this=0Achange to ensure that no problems are being intro=
duced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukh=
erjee@gmail.com>=0A---=0A sound/soc/img/img-i2s-in.c | 1 -=0A 1 file change=
d, 1 deletion(-)=0A=0Adiff --git a/sound/soc/img/img-i2s-in.c b/sound/soc/i=
mg/img-i2s-in.c=0Aindex bb668551dd4b..bd4cf8a48bae 100644=0A--- a/sound/soc=
/img/img-i2s-in.c=0A+++ b/sound/soc/img/img-i2s-in.c=0A@@ -484,7 +484,6 @@ =
static int img_i2s_in_probe(struct platform_device *pdev)=0A 	if (IS_ERR(rs=
t)) {=0A 		if (PTR_ERR(rst) =3D=3D -EPROBE_DEFER) {=0A 			ret =3D -EPROBE_D=
EFER;=0A-			pm_runtime_put(&pdev->dev);=0A 			goto err_suspend;=0A 		}=0A =
=0A-- =0A2.30.2=0A=0A=0AFrom 13a095e845fb9a409900574583ff3cb965e5e49e Mon S=
ep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A=
Date: Wed, 21 Apr 2021 20:26:29 +0100=0ASubject: [PATCH 132/151] Revert "ql=
cnic: fix missing release in=0A qlcnic_83xx_interrupt_test."=0A=0AThis reve=
rts commit a369e8378b48aa8fc93e574e5df7e198cfb88cd4.=0A=0ACommits from @umn=
=2Eedu addresses have been found to be submitted in "bad=0Afaith" to try to=
 test the kernel community's ability to review "known=0Amalicious" changes.=
  The result of these submissions can be found in a=0Apaper published at th=
e 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Open Source Inse=
curity: Stealthily Introducing=0AVulnerabilities via Hypocrite Commits" wri=
tten by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (University of=
 Minnesota).=0A=0ABecause of this, all submissions from this group must be =
reverted from=0Athe kernel tree and will need to be re-reviewed again to de=
termine if=0Athey actually are a valid fix.  Until that work is complete, r=
emove this=0Achange to ensure that no problems are being introduced into th=
e=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.c=
om>=0A---=0A drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c | 4 +---=
=0A 1 file changed, 1 insertion(+), 3 deletions(-)=0A=0Adiff --git a/driver=
s/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c b/drivers/net/ethernet/qlogic=
/qlcnic/qlcnic_83xx_hw.c=0Aindex 29b9c728a65e..2a533280b124 100644=0A--- a/=
drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c=0A+++ b/drivers/net/eth=
ernet/qlogic/qlcnic/qlcnic_83xx_hw.c=0A@@ -3651,7 +3651,7 @@ int qlcnic_83x=
x_interrupt_test(struct net_device *netdev)=0A 	ahw->diag_cnt =3D 0;=0A 	re=
t =3D qlcnic_alloc_mbx_args(&cmd, adapter, QLCNIC_CMD_INTRPT_TEST);=0A 	if =
(ret)=0A-		goto fail_mbx_args;=0A+		goto fail_diag_irq;=0A =0A 	if (adapter=
->flags & QLCNIC_MSIX_ENABLED)=0A 		intrpt_id =3D ahw->intr_tbl[0].id;=0A@@=
 -3681,8 +3681,6 @@ int qlcnic_83xx_interrupt_test(struct net_device *netde=
v)=0A =0A done:=0A 	qlcnic_free_mbx_args(&cmd);=0A-=0A-fail_mbx_args:=0A 	q=
lcnic_83xx_diag_free_res(netdev, drv_sds_rings);=0A =0A fail_diag_irq:=0A--=
 =0A2.30.2=0A=0A=0AFrom 92867747fb298dbb0327708ca57c02b5478647aa Mon Sep 17=
 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate:=
 Wed, 21 Apr 2021 20:26:29 +0100=0ASubject: [PATCH 133/151] Revert "usb: ga=
dget: fix potential double-free in=0A m66592_probe."=0A=0AThis reverts comm=
it 84e1326ffc6164c396e58170cc14c9a50e7eea2e.=0A=0ACommits from @umn.edu add=
resses have been found to be submitted in "bad=0Afaith" to try to test the =
kernel community's ability to review "known=0Amalicious" changes.  The resu=
lt of these submissions can be found in a=0Apaper published at the 42nd IEE=
E Symposium on Security and Privacy=0Aentitled, "Open Source Insecurity: St=
ealthily Introducing=0AVulnerabilities via Hypocrite Commits" written by Qi=
ushi Wu (University=0Aof Minnesota) and Kangjie Lu (University of Minnesota=
).=0A=0ABecause of this, all submissions from this group must be reverted f=
rom=0Athe kernel tree and will need to be re-reviewed again to determine if=
=0Athey actually are a valid fix.  Until that work is complete, remove this=
=0Achange to ensure that no problems are being introduced into the=0Acodeba=
se.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=
=0A drivers/usb/gadget/udc/m66592-udc.c | 2 +-=0A 1 file changed, 1 inserti=
on(+), 1 deletion(-)=0A=0Adiff --git a/drivers/usb/gadget/udc/m66592-udc.c =
b/drivers/usb/gadget/udc/m66592-udc.c=0Aindex ea59b56e5402..a8288df6aadf 10=
0644=0A--- a/drivers/usb/gadget/udc/m66592-udc.c=0A+++ b/drivers/usb/gadget=
/udc/m66592-udc.c=0A@@ -1667,7 +1667,7 @@ static int m66592_probe(struct pl=
atform_device *pdev)=0A =0A err_add_udc:=0A 	m66592_free_request(&m66592->e=
p[0].ep, m66592->ep0_req);=0A-	m66592->ep0_req =3D NULL;=0A+=0A clean_up3:=
=0A 	if (m66592->pdata->on_chip) {=0A 		clk_disable(m66592->clk);=0A-- =0A2=
=2E30.2=0A=0A=0AFrom 2109460e22547790eefa1c0e529d91f9d1b975d3 Mon Sep 17 00=
:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: We=
d, 21 Apr 2021 20:26:29 +0100=0ASubject: [PATCH 134/151] Revert "net/mlx4_c=
ore: fix a memory leak bug."=0A=0AThis reverts commit 9aeacb829cad22892a176=
d6fcaa7ca8da6021b4e.=0A=0ACommits from @umn.edu addresses have been found t=
o be submitted in "bad=0Afaith" to try to test the kernel community's abili=
ty to review "known=0Amalicious" changes.  The result of these submissions =
can be found in a=0Apaper published at the 42nd IEEE Symposium on Security =
and Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AV=
ulnerabilities via Hypocrite Commits" written by Qiushi Wu (University=0Aof=
 Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this,=
 all submissions from this group must be reverted from=0Athe kernel tree an=
d will need to be re-reviewed again to determine if=0Athey actually are a v=
alid fix.  Until that work is complete, remove this=0Achange to ensure that=
 no problems are being introduced into the=0Acodebase.=0A=0ASigned-off-by: =
Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/ethernet/=
mellanox/mlx4/fw.c | 2 +-=0A 1 file changed, 1 insertion(+), 1 deletion(-)=
=0A=0Adiff --git a/drivers/net/ethernet/mellanox/mlx4/fw.c b/drivers/net/et=
hernet/mellanox/mlx4/fw.c=0Aindex f6cfec81ccc3..380e027ba5df 100644=0A--- a=
/drivers/net/ethernet/mellanox/mlx4/fw.c=0A+++ b/drivers/net/ethernet/mella=
nox/mlx4/fw.c=0A@@ -2734,7 +2734,7 @@ void mlx4_opreq_action(struct work_st=
ruct *work)=0A 		if (err) {=0A 			mlx4_err(dev, "Failed to retrieve require=
d operation: %d\n",=0A 				 err);=0A-			goto out;=0A+			return;=0A 		}=0A 	=
	MLX4_GET(modifier, outbox, GET_OP_REQ_MODIFIER_OFFSET);=0A 		MLX4_GET(toke=
n, outbox, GET_OP_REQ_TOKEN_OFFSET);=0A-- =0A2.30.2=0A=0A=0AFrom 56da8a229f=
dbb5fc37c46b59c79578670e72fc18 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukhe=
rjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:26:30 +0100=
=0ASubject: [PATCH 135/151] Revert "test_objagg: Fix potential memory leak =
in=0A error handling"=0A=0AThis reverts commit 8dba9173a37a53197971c39f752d=
07e6bc1a50d0.=0A=0ACommits from @umn.edu addresses have been found to be su=
bmitted in "bad=0Afaith" to try to test the kernel community's ability to r=
eview "known=0Amalicious" changes.  The result of these submissions can be =
found in a=0Apaper published at the 42nd IEEE Symposium on Security and Pri=
vacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVulnerab=
ilities via Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnes=
ota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, all su=
bmissions from this group must be reverted from=0Athe kernel tree and will =
need to be re-reviewed again to determine if=0Athey actually are a valid fi=
x.  Until that work is complete, remove this=0Achange to ensure that no pro=
blems are being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip M=
ukherjee <sudipm.mukherjee@gmail.com>=0A---=0A lib/test_objagg.c | 4 ++--=
=0A 1 file changed, 2 insertions(+), 2 deletions(-)=0A=0Adiff --git a/lib/t=
est_objagg.c b/lib/test_objagg.c=0Aindex da137939a410..72c1abfa154d 100644=
=0A--- a/lib/test_objagg.c=0A+++ b/lib/test_objagg.c=0A@@ -979,10 +979,10 @=
@ static int test_hints_case(const struct hints_case *hints_case)=0A err_wo=
rld2_obj_get:=0A 	for (i--; i >=3D 0; i--)=0A 		world_obj_put(&world2, obja=
gg, hints_case->key_ids[i]);=0A-	i =3D hints_case->key_ids_count;=0A+	objag=
g_hints_put(hints);=0A 	objagg_destroy(objagg2);=0A+	i =3D hints_case->key_=
ids_count;=0A err_check_expect_hints_stats:=0A-	objagg_hints_put(hints);=0A=
 err_hints_get:=0A err_check_expect_stats:=0A err_world_obj_get:=0A-- =0A2.=
30.2=0A=0A=0AFrom 928ec1bf56003cf25216a2f8dca8212a47720c0d Mon Sep 17 00:00=
:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, =
21 Apr 2021 20:26:30 +0100=0ASubject: [PATCH 136/151] Revert "agp/intel: Fi=
x a memory leak on module=0A initialisation failure"=0A=0AThis reverts comm=
it e3b04e1b5b03e46488666d081adf1046afc7635a.=0A=0ACommits from @umn.edu add=
resses have been found to be submitted in "bad=0Afaith" to try to test the =
kernel community's ability to review "known=0Amalicious" changes.  The resu=
lt of these submissions can be found in a=0Apaper published at the 42nd IEE=
E Symposium on Security and Privacy=0Aentitled, "Open Source Insecurity: St=
ealthily Introducing=0AVulnerabilities via Hypocrite Commits" written by Qi=
ushi Wu (University=0Aof Minnesota) and Kangjie Lu (University of Minnesota=
).=0A=0ABecause of this, all submissions from this group must be reverted f=
rom=0Athe kernel tree and will need to be re-reviewed again to determine if=
=0Athey actually are a valid fix.  Until that work is complete, remove this=
=0Achange to ensure that no problems are being introduced into the=0Acodeba=
se.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=
=0A drivers/char/agp/intel-gtt.c | 4 +---=0A 1 file changed, 1 insertion(+)=
, 3 deletions(-)=0A=0Adiff --git a/drivers/char/agp/intel-gtt.c b/drivers/c=
har/agp/intel-gtt.c=0Aindex 0941d38b2d32..b161bdf60000 100644=0A--- a/drive=
rs/char/agp/intel-gtt.c=0A+++ b/drivers/char/agp/intel-gtt.c=0A@@ -304,10 +=
304,8 @@ static int intel_gtt_setup_scratch_page(void)=0A 	if (intel_privat=
e.needs_dmar) {=0A 		dma_addr =3D pci_map_page(intel_private.pcidev, page, =
0,=0A 				    PAGE_SIZE, PCI_DMA_BIDIRECTIONAL);=0A-		if (pci_dma_mapping_e=
rror(intel_private.pcidev, dma_addr)) {=0A-			__free_page(page);=0A+		if (p=
ci_dma_mapping_error(intel_private.pcidev, dma_addr))=0A 			return -EINVAL;=
=0A-		}=0A =0A 		intel_private.scratch_page_dma =3D dma_addr;=0A 	} else=0A=
-- =0A2.30.2=0A=0A=0AFrom 938809a17f52d3e462d404ef83918fa84f91e1f0 Mon Sep =
17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADat=
e: Wed, 21 Apr 2021 20:26:30 +0100=0ASubject: [PATCH 137/151] Revert "ecryp=
tfs: replace BUG_ON with error handling=0A code"=0A=0AThis reverts commit c=
fde4697ea4d66c7bfb1599eef189211471b2c38.=0A=0ACommits from @umn.edu address=
es have been found to be submitted in "bad=0Afaith" to try to test the kern=
el community's ability to review "known=0Amalicious" changes.  The result o=
f these submissions can be found in a=0Apaper published at the 42nd IEEE Sy=
mposium on Security and Privacy=0Aentitled, "Open Source Insecurity: Stealt=
hily Introducing=0AVulnerabilities via Hypocrite Commits" written by Qiushi=
 Wu (University=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=
=0A=0ABecause of this, all submissions from this group must be reverted fro=
m=0Athe kernel tree and will need to be re-reviewed again to determine if=
=0Athey actually are a valid fix.  Until that work is complete, remove this=
=0Achange to ensure that no problems are being introduced into the=0Acodeba=
se.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=
=0A fs/ecryptfs/crypto.c | 6 ++----=0A 1 file changed, 2 insertions(+), 4 d=
eletions(-)=0A=0Adiff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c=
=0Aindex a064b408d841..f91db24bbf3b 100644=0A--- a/fs/ecryptfs/crypto.c=0A+=
++ b/fs/ecryptfs/crypto.c=0A@@ -311,10 +311,8 @@ static int crypt_scatterli=
st(struct ecryptfs_crypt_stat *crypt_stat,=0A 	struct extent_crypt_result e=
cr;=0A 	int rc =3D 0;=0A =0A-	if (!crypt_stat || !crypt_stat->tfm=0A-	     =
  || !(crypt_stat->flags & ECRYPTFS_STRUCT_INITIALIZED))=0A-		return -EINVA=
L;=0A-=0A+	BUG_ON(!crypt_stat || !crypt_stat->tfm=0A+	       || !(crypt_sta=
t->flags & ECRYPTFS_STRUCT_INITIALIZED));=0A 	if (unlikely(ecryptfs_verbosi=
ty > 0)) {=0A 		ecryptfs_printk(KERN_DEBUG, "Key size [%zd]; key:\n",=0A 		=
		crypt_stat->key_size);=0A-- =0A2.30.2=0A=0A=0AFrom 94c7048eb500adad6b8d2a=
8f7d9e795fbeea214f Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm=
=2Emukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:26:30 +0100=0ASubject: =
[PATCH 138/151] Revert "net: sun: fix missing release regions in=0A cas_ini=
t_one()."=0A=0AThis reverts commit fcb4d5869e981738c5c3bd38a9a8fcdce8e012b6=
=2E=0A=0ACommits from @umn.edu addresses have been found to be submitted in=
 "bad=0Afaith" to try to test the kernel community's ability to review "kno=
wn=0Amalicious" changes.  The result of these submissions can be found in a=
=0Apaper published at the 42nd IEEE Symposium on Security and Privacy=0Aent=
itled, "Open Source Insecurity: Stealthily Introducing=0AVulnerabilities vi=
a Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnesota) and K=
angjie Lu (University of Minnesota).=0A=0ABecause of this, all submissions =
=66rom this group must be reverted from=0Athe kernel tree and will need to =
be re-reviewed again to determine if=0Athey actually are a valid fix.  Unti=
l that work is complete, remove this=0Achange to ensure that no problems ar=
e being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee=
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/ethernet/sun/cassini.c |=
 3 ++-=0A 1 file changed, 2 insertions(+), 1 deletion(-)=0A=0Adiff --git a/=
drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/sun/cassini.c=0Ai=
ndex 6e78a33aa5e4..c91876f8c536 100644=0A--- a/drivers/net/ethernet/sun/cas=
sini.c=0A+++ b/drivers/net/ethernet/sun/cassini.c=0A@@ -4971,7 +4971,7 @@ s=
tatic int cas_init_one(struct pci_dev *pdev, const struct pci_device_id *en=
t)=0A 					  cas_cacheline_size)) {=0A 			dev_err(&pdev->dev, "Could not se=
t PCI cache "=0A 			       "line size\n");=0A-			goto err_out_free_res;=0A+=
			goto err_write_cacheline;=0A 		}=0A 	}=0A #endif=0A@@ -5144,6 +5144,7 @@=
 static int cas_init_one(struct pci_dev *pdev, const struct pci_device_id *=
ent)=0A err_out_free_res:=0A 	pci_release_regions(pdev);=0A =0A+err_write_c=
acheline:=0A 	/* Try to restore it in case the error occurred after we=0A 	=
 * set it.=0A 	 */=0A-- =0A2.30.2=0A=0A=0AFrom 0cf764cf111aed3a74af1d2501a8=
553336221a63 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukhe=
rjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:26:31 +0100=0ASubject: [PATCH 1=
39/151] Revert "ASoC: img-parallel-out: Fix a reference count=0A leak"=0A=
=0AThis reverts commit 7d60cd2a6e08e914e3ebaa4f677f91c85eb27c74.=0A=0ACommi=
ts from @umn.edu addresses have been found to be submitted in "bad=0Afaith"=
 to try to test the kernel community's ability to review "known=0Amalicious=
" changes.  The result of these submissions can be found in a=0Apaper publi=
shed at the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Open S=
ource Insecurity: Stealthily Introducing=0AVulnerabilities via Hypocrite Co=
mmits" written by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (Uni=
versity of Minnesota).=0A=0ABecause of this, all submissions from this grou=
p must be reverted from=0Athe kernel tree and will need to be re-reviewed a=
gain to determine if=0Athey actually are a valid fix.  Until that work is c=
omplete, remove this=0Achange to ensure that no problems are being introduc=
ed into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherj=
ee@gmail.com>=0A---=0A sound/soc/img/img-parallel-out.c | 4 +---=0A 1 file =
changed, 1 insertion(+), 3 deletions(-)=0A=0Adiff --git a/sound/soc/img/img=
-parallel-out.c b/sound/soc/img/img-parallel-out.c=0Aindex 4da49a42e854..5d=
dbe3a31c2e 100644=0A--- a/sound/soc/img/img-parallel-out.c=0A+++ b/sound/so=
c/img/img-parallel-out.c=0A@@ -163,10 +163,8 @@ static int img_prl_out_set_=
fmt(struct snd_soc_dai *dai, unsigned int fmt)=0A 	}=0A =0A 	ret =3D pm_run=
time_get_sync(prl->dev);=0A-	if (ret < 0) {=0A-		pm_runtime_put_noidle(prl-=
>dev);=0A+	if (ret < 0)=0A 		return ret;=0A-	}=0A =0A 	reg =3D img_prl_out_=
readl(prl, IMG_PRL_OUT_CTL);=0A 	reg =3D (reg & ~IMG_PRL_OUT_CTL_EDGE_MASK)=
 | control_set;=0A-- =0A2.30.2=0A=0A=0AFrom 3654c75e1e5f20a93543f2fe20c65a3=
f1e6e07f4 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherje=
e@gmail.com>=0ADate: Wed, 21 Apr 2021 20:26:31 +0100=0ASubject: [PATCH 140/=
151] Revert "efi/esrt: Fix reference count leak in=0A esre_create_sysfs_ent=
ry."=0A=0AThis reverts commit 92444a57e3656ac0c11972f2ace4b356ecb15795.=0A=
=0ACommits from @umn.edu addresses have been found to be submitted in "bad=
=0Afaith" to try to test the kernel community's ability to review "known=0A=
malicious" changes.  The result of these submissions can be found in a=0Apa=
per published at the 42nd IEEE Symposium on Security and Privacy=0Aentitled=
, "Open Source Insecurity: Stealthily Introducing=0AVulnerabilities via Hyp=
ocrite Commits" written by Qiushi Wu (University=0Aof Minnesota) and Kangji=
e Lu (University of Minnesota).=0A=0ABecause of this, all submissions from =
this group must be reverted from=0Athe kernel tree and will need to be re-r=
eviewed again to determine if=0Athey actually are a valid fix.  Until that =
work is complete, remove this=0Achange to ensure that no problems are being=
 introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudip=
m.mukherjee@gmail.com>=0A---=0A drivers/firmware/efi/esrt.c | 2 +-=0A 1 fil=
e changed, 1 insertion(+), 1 deletion(-)=0A=0Adiff --git a/drivers/firmware=
/efi/esrt.c b/drivers/firmware/efi/esrt.c=0Aindex e8f71a50ba89..d6dd5f503fa=
2 100644=0A--- a/drivers/firmware/efi/esrt.c=0A+++ b/drivers/firmware/efi/e=
srt.c=0A@@ -181,7 +181,7 @@ static int esre_create_sysfs_entry(void *esre, =
int entry_num)=0A 		rc =3D kobject_init_and_add(&entry->kobj, &esre1_ktype,=
 NULL,=0A 					  "entry%d", entry_num);=0A 		if (rc) {=0A-			kobject_put(&e=
ntry->kobj);=0A+			kfree(entry);=0A 			return rc;=0A 		}=0A 	}=0A-- =0A2.30=
=2E2=0A=0A=0AFrom 93042050e59028a47408a489934938bbbd43ec4a Mon Sep 17 00:00=
:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, =
21 Apr 2021 20:26:31 +0100=0ASubject: [PATCH 141/151] Revert "ASoC: img: Fi=
x a reference count leak in=0A img_i2s_in_set_fmt"=0A=0AThis reverts commit=
 8150a0e3d796a5ddeef0731a0f52b74f0393ec2f.=0A=0ACommits from @umn.edu addre=
sses have been found to be submitted in "bad=0Afaith" to try to test the ke=
rnel community's ability to review "known=0Amalicious" changes.  The result=
 of these submissions can be found in a=0Apaper published at the 42nd IEEE =
Symposium on Security and Privacy=0Aentitled, "Open Source Insecurity: Stea=
lthily Introducing=0AVulnerabilities via Hypocrite Commits" written by Qius=
hi Wu (University=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=
=0A=0ABecause of this, all submissions from this group must be reverted fro=
m=0Athe kernel tree and will need to be re-reviewed again to determine if=
=0Athey actually are a valid fix.  Until that work is complete, remove this=
=0Achange to ensure that no problems are being introduced into the=0Acodeba=
se.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=
=0A sound/soc/img/img-i2s-in.c | 4 +---=0A 1 file changed, 1 insertion(+), =
3 deletions(-)=0A=0Adiff --git a/sound/soc/img/img-i2s-in.c b/sound/soc/img=
/img-i2s-in.c=0Aindex bd4cf8a48bae..fdd2c73fd2fa 100644=0A--- a/sound/soc/i=
mg/img-i2s-in.c=0A+++ b/sound/soc/img/img-i2s-in.c=0A@@ -343,10 +343,8 @@ s=
tatic int img_i2s_in_set_fmt(struct snd_soc_dai *dai, unsigned int fmt)=0A =
	chan_control_mask =3D IMG_I2S_IN_CH_CTL_CLK_TRANS_MASK;=0A =0A 	ret =3D pm=
_runtime_get_sync(i2s->dev);=0A-	if (ret < 0) {=0A-		pm_runtime_put_noidle(=
i2s->dev);=0A+	if (ret < 0)=0A 		return ret;=0A-	}=0A =0A 	for (i =3D 0; i =
< i2s->active_channels; i++)=0A 		img_i2s_in_ch_disable(i2s, i);=0A-- =0A2.=
30.2=0A=0A=0AFrom 93f044376b535fc0dd27bed69bcafc42fff7dce3 Mon Sep 17 00:00=
:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, =
21 Apr 2021 20:26:32 +0100=0ASubject: [PATCH 142/151] Revert "scsi: iscsi: =
Fix reference count leak in=0A iscsi_boot_create_kobj"=0A=0AThis reverts co=
mmit 88d67834843019721d94cd63e077e2499c480d0b.=0A=0ACommits from @umn.edu a=
ddresses have been found to be submitted in "bad=0Afaith" to try to test th=
e kernel community's ability to review "known=0Amalicious" changes.  The re=
sult of these submissions can be found in a=0Apaper published at the 42nd I=
EEE Symposium on Security and Privacy=0Aentitled, "Open Source Insecurity: =
Stealthily Introducing=0AVulnerabilities via Hypocrite Commits" written by =
Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (University of Minneso=
ta).=0A=0ABecause of this, all submissions from this group must be reverted=
 from=0Athe kernel tree and will need to be re-reviewed again to determine =
if=0Athey actually are a valid fix.  Until that work is complete, remove th=
is=0Achange to ensure that no problems are being introduced into the=0Acode=
base.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A--=
-=0A drivers/scsi/iscsi_boot_sysfs.c | 2 +-=0A 1 file changed, 1 insertion(=
+), 1 deletion(-)=0A=0Adiff --git a/drivers/scsi/iscsi_boot_sysfs.c b/drive=
rs/scsi/iscsi_boot_sysfs.c=0Aindex a64abe38db2d..e4857b728033 100644=0A--- =
a/drivers/scsi/iscsi_boot_sysfs.c=0A+++ b/drivers/scsi/iscsi_boot_sysfs.c=
=0A@@ -352,7 +352,7 @@ iscsi_boot_create_kobj(struct iscsi_boot_kset *boot_=
kset,=0A 	boot_kobj->kobj.kset =3D boot_kset->kset;=0A 	if (kobject_init_an=
d_add(&boot_kobj->kobj, &iscsi_boot_ktype,=0A 				 NULL, name, index)) {=0A=
-		kobject_put(&boot_kobj->kobj);=0A+		kfree(boot_kobj);=0A 		return NULL;=
=0A 	}=0A 	boot_kobj->data =3D data;=0A-- =0A2.30.2=0A=0A=0AFrom 357c9eb083=
4e56ea28bb11f2f7c7c5a16f69bb3a Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukhe=
rjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:26:32 +0100=
=0ASubject: [PATCH 143/151] Revert "vfio/mdev: Fix reference count leak in=
=0A add_mdev_supported_type"=0A=0AThis reverts commit f4fbb592d9d72d85bc6a6=
2b0a18a09d3d9a7c4e6.=0A=0ACommits from @umn.edu addresses have been found t=
o be submitted in "bad=0Afaith" to try to test the kernel community's abili=
ty to review "known=0Amalicious" changes.  The result of these submissions =
can be found in a=0Apaper published at the 42nd IEEE Symposium on Security =
and Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AV=
ulnerabilities via Hypocrite Commits" written by Qiushi Wu (University=0Aof=
 Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this,=
 all submissions from this group must be reverted from=0Athe kernel tree an=
d will need to be re-reviewed again to determine if=0Athey actually are a v=
alid fix.  Until that work is complete, remove this=0Achange to ensure that=
 no problems are being introduced into the=0Acodebase.=0A=0ASigned-off-by: =
Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/vfio/mdev/mde=
v_sysfs.c | 2 +-=0A 1 file changed, 1 insertion(+), 1 deletion(-)=0A=0Adiff=
 --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c=0A=
index f32c582611eb..7570c7602ab4 100644=0A--- a/drivers/vfio/mdev/mdev_sysf=
s.c=0A+++ b/drivers/vfio/mdev/mdev_sysfs.c=0A@@ -110,7 +110,7 @@ static str=
uct mdev_type *add_mdev_supported_type(struct mdev_parent *parent,=0A 				 =
  "%s-%s", dev_driver_string(parent->dev),=0A 				   group->name);=0A 	if (=
ret) {=0A-		kobject_put(&type->kobj);=0A+		kfree(type);=0A 		return ERR_PTR=
(ret);=0A 	}=0A =0A-- =0A2.30.2=0A=0A=0AFrom 666907e7e5e94905cb097731f0bce8=
3b02d356dc Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherj=
ee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:26:32 +0100=0ASubject: [PATCH 144=
/151] Revert "RDMA/core: Fix several reference count=0A leaks."=0A=0AThis r=
everts commit c0c8c8b10567f79f296200847f554b12a38f313d.=0A=0ACommits from @=
umn.edu addresses have been found to be submitted in "bad=0Afaith" to try t=
o test the kernel community's ability to review "known=0Amalicious" changes=
=2E  The result of these submissions can be found in a=0Apaper published at=
 the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Open Source I=
nsecurity: Stealthily Introducing=0AVulnerabilities via Hypocrite Commits" =
written by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (University=
 of Minnesota).=0A=0ABecause of this, all submissions from this group must =
be reverted from=0Athe kernel tree and will need to be re-reviewed again to=
 determine if=0Athey actually are a valid fix.  Until that work is complete=
, remove this=0Achange to ensure that no problems are being introduced into=
 the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmai=
l.com>=0A---=0A drivers/infiniband/core/sysfs.c | 10 +++++-----=0A 1 file c=
hanged, 5 insertions(+), 5 deletions(-)=0A=0Adiff --git a/drivers/infiniban=
d/core/sysfs.c b/drivers/infiniband/core/sysfs.c=0Aindex 091cca9d88ed..7a50=
cedcef1f 100644=0A--- a/drivers/infiniband/core/sysfs.c=0A+++ b/drivers/inf=
iniband/core/sysfs.c=0A@@ -1060,7 +1060,8 @@ static int add_port(struct ib_=
core_device *coredev, int port_num)=0A 				   coredev->ports_kobj,=0A 				 =
  "%d", port_num);=0A 	if (ret) {=0A-		goto err_put;=0A+		kfree(p);=0A+		re=
turn ret;=0A 	}=0A =0A 	p->gid_attr_group =3D kzalloc(sizeof(*p->gid_attr_g=
roup), GFP_KERNEL);=0A@@ -1073,7 +1074,8 @@ static int add_port(struct ib_c=
ore_device *coredev, int port_num)=0A 	ret =3D kobject_init_and_add(&p->gid=
_attr_group->kobj, &gid_attr_type,=0A 				   &p->kobj, "gid_attrs");=0A 	if=
 (ret) {=0A-		goto err_put_gid_attrs;=0A+		kfree(p->gid_attr_group);=0A+		g=
oto err_put;=0A 	}=0A =0A 	if (device->ops.process_mad && is_full_dev) {=0A=
@@ -1404,10 +1406,8 @@ int ib_port_register_module_stat(struct ib_device *d=
evice, u8 port_num,=0A =0A 		ret =3D kobject_init_and_add(kobj, ktype, &por=
t->kobj, "%s",=0A 					   name);=0A-		if (ret) {=0A-			kobject_put(kobj);=
=0A+		if (ret)=0A 			return ret;=0A-		}=0A 	}=0A =0A 	return 0;=0A-- =0A2.3=
0.2=0A=0A=0AFrom 485c992ed5751471d2dcdce4ac8b7921f79ef453 Mon Sep 17 00:00:=
00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 2=
1 Apr 2021 20:26:32 +0100=0ASubject: [PATCH 145/151] Revert "cpuidle: Fix t=
hree reference count leaks"=0A=0AThis reverts commit b77412359c1e6b44b37365=
a11d0f434426783208.=0A=0ACommits from @umn.edu addresses have been found to=
 be submitted in "bad=0Afaith" to try to test the kernel community's abilit=
y to review "known=0Amalicious" changes.  The result of these submissions c=
an be found in a=0Apaper published at the 42nd IEEE Symposium on Security a=
nd Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVu=
lnerabilities via Hypocrite Commits" written by Qiushi Wu (University=0Aof =
Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, =
all submissions from this group must be reverted from=0Athe kernel tree and=
 will need to be re-reviewed again to determine if=0Athey actually are a va=
lid fix.  Until that work is complete, remove this=0Achange to ensure that =
no problems are being introduced into the=0Acodebase.=0A=0ASigned-off-by: S=
udip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/cpuidle/sysfs.=
c | 6 +++---=0A 1 file changed, 3 insertions(+), 3 deletions(-)=0A=0Adiff -=
-git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c=0Aindex f8747322b3=
c7..2bb2683b493c 100644=0A--- a/drivers/cpuidle/sysfs.c=0A+++ b/drivers/cpu=
idle/sysfs.c=0A@@ -480,7 +480,7 @@ static int cpuidle_add_state_sysfs(struc=
t cpuidle_device *device)=0A 		ret =3D kobject_init_and_add(&kobj->kobj, &k=
type_state_cpuidle,=0A 					   &kdev->kobj, "state%d", i);=0A 		if (ret) {=
=0A-			kobject_put(&kobj->kobj);=0A+			kfree(kobj);=0A 			goto error_state;=
=0A 		}=0A 		cpuidle_add_s2idle_attr_group(kobj);=0A@@ -611,7 +611,7 @@ sta=
tic int cpuidle_add_driver_sysfs(struct cpuidle_device *dev)=0A 	ret =3D ko=
bject_init_and_add(&kdrv->kobj, &ktype_driver_cpuidle,=0A 				   &kdev->kob=
j, "driver");=0A 	if (ret) {=0A-		kobject_put(&kdrv->kobj);=0A+		kfree(kdrv=
);=0A 		return ret;=0A 	}=0A =0A@@ -705,7 +705,7 @@ int cpuidle_add_sysfs(s=
truct cpuidle_device *dev)=0A 	error =3D kobject_init_and_add(&kdev->kobj, =
&ktype_cpuidle, &cpu_dev->kobj,=0A 				   "cpuidle");=0A 	if (error) {=0A-	=
	kobject_put(&kdev->kobj);=0A+		kfree(kdev);=0A 		return error;=0A 	}=0A =
=0A-- =0A2.30.2=0A=0A=0AFrom 3b329eb9f3801d77bbc7399e15b58ac6b597a7c5 Mon S=
ep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A=
Date: Wed, 21 Apr 2021 20:26:33 +0100=0ASubject: [PATCH 146/151] Revert "ED=
AC: Fix reference count leaks"=0A=0AThis reverts commit c73eec04e6665f020ff=
b38890612811c12392afe.=0A=0ACommits from @umn.edu addresses have been found=
 to be submitted in "bad=0Afaith" to try to test the kernel community's abi=
lity to review "known=0Amalicious" changes.  The result of these submission=
s can be found in a=0Apaper published at the 42nd IEEE Symposium on Securit=
y and Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=
=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu (University=
=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of =
this, all submissions from this group must be reverted from=0Athe kernel tr=
ee and will need to be re-reviewed again to determine if=0Athey actually ar=
e a valid fix.  Until that work is complete, remove this=0Achange to ensure=
 that no problems are being introduced into the=0Acodebase.=0A=0ASigned-off=
-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/edac/eda=
c_device_sysfs.c | 1 -=0A drivers/edac/edac_pci_sysfs.c    | 2 +-=0A 2 file=
s changed, 1 insertion(+), 2 deletions(-)=0A=0Adiff --git a/drivers/edac/ed=
ac_device_sysfs.c b/drivers/edac/edac_device_sysfs.c=0Aindex 5e7593753799..=
0e7ea3591b78 100644=0A--- a/drivers/edac/edac_device_sysfs.c=0A+++ b/driver=
s/edac/edac_device_sysfs.c=0A@@ -275,7 +275,6 @@ int edac_device_register_s=
ysfs_main_kobj(struct edac_device_ctl_info *edac_dev)=0A =0A 	/* Error exit=
 stack */=0A err_kobj_reg:=0A-	kobject_put(&edac_dev->kobj);=0A 	module_put=
(edac_dev->owner);=0A =0A err_out:=0Adiff --git a/drivers/edac/edac_pci_sys=
fs.c b/drivers/edac/edac_pci_sysfs.c=0Aindex 53042af7262e..72c9eb9fdffb 100=
644=0A--- a/drivers/edac/edac_pci_sysfs.c=0A+++ b/drivers/edac/edac_pci_sys=
fs.c=0A@@ -386,7 +386,7 @@ static int edac_pci_main_kobj_setup(void)=0A =0A=
 	/* Error unwind statck */=0A kobject_init_and_add_fail:=0A-	kobject_put(e=
dac_pci_top_main_kobj);=0A+	kfree(edac_pci_top_main_kobj);=0A =0A kzalloc_f=
ail:=0A 	module_put(THIS_MODULE);=0A-- =0A2.30.2=0A=0A=0AFrom aead6bf3b0f4c=
2e0eb6decc46bf5b6ae3dcd0e6f Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherje=
e <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:26:33 +0100=0ASu=
bject: [PATCH 147/151] Revert "fore200e: Fix incorrect checks of NULL=0A po=
inter dereference"=0A=0AThis reverts commit 1e2b6e5f32aabf201c01457b1dabf8c=
7a161a47d.=0A=0ACommits from @umn.edu addresses have been found to be submi=
tted in "bad=0Afaith" to try to test the kernel community's ability to revi=
ew "known=0Amalicious" changes.  The result of these submissions can be fou=
nd in a=0Apaper published at the 42nd IEEE Symposium on Security and Privac=
y=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVulnerabili=
ties via Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnesota=
) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, all submi=
ssions from this group must be reverted from=0Athe kernel tree and will nee=
d to be re-reviewed again to determine if=0Athey actually are a valid fix. =
 Until that work is complete, remove this=0Achange to ensure that no proble=
ms are being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukh=
erjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/atm/fore200e.c | 25 +++=
++++------------------=0A 1 file changed, 7 insertions(+), 18 deletions(-)=
=0A=0Adiff --git a/drivers/atm/fore200e.c b/drivers/atm/fore200e.c=0Aindex =
8fbd36eb8941..f1a500205313 100644=0A--- a/drivers/atm/fore200e.c=0A+++ b/dr=
ivers/atm/fore200e.c=0A@@ -1414,14 +1414,12 @@ fore200e_open(struct atm_vcc=
 *vcc)=0A static void=0A fore200e_close(struct atm_vcc* vcc)=0A {=0A+    st=
ruct fore200e*        fore200e =3D FORE200E_DEV(vcc->dev);=0A     struct fo=
re200e_vcc*    fore200e_vcc;=0A-    struct fore200e*        fore200e;=0A   =
  struct fore200e_vc_map* vc_map;=0A     unsigned long           flags;=0A =
=0A     ASSERT(vcc);=0A-    fore200e =3D FORE200E_DEV(vcc->dev);=0A-=0A    =
 ASSERT((vcc->vpi >=3D 0) && (vcc->vpi < 1<<FORE200E_VPI_BITS));=0A     ASS=
ERT((vcc->vci >=3D 0) && (vcc->vci < 1<<FORE200E_VCI_BITS));=0A =0A@@ -1466=
,10 +1464,10 @@ fore200e_close(struct atm_vcc* vcc)=0A static int=0A fore20=
0e_send(struct atm_vcc *vcc, struct sk_buff *skb)=0A {=0A-    struct fore20=
0e*        fore200e;=0A-    struct fore200e_vcc*    fore200e_vcc;=0A+    st=
ruct fore200e*        fore200e     =3D FORE200E_DEV(vcc->dev);=0A+    struc=
t fore200e_vcc*    fore200e_vcc =3D FORE200E_VCC(vcc);=0A     struct fore20=
0e_vc_map* vc_map;=0A-    struct host_txq*        txq;=0A+    struct host_t=
xq*        txq          =3D &fore200e->host_txq;=0A     struct host_txq_ent=
ry*  entry;=0A     struct tpd*             tpd;=0A     struct tpd_haddr    =
    tpd_haddr;=0A@@ -1482,18 +1480,9 @@ fore200e_send(struct atm_vcc *vcc, =
struct sk_buff *skb)=0A     unsigned char*          data;=0A     unsigned l=
ong           flags;=0A =0A-    if (!vcc)=0A-        return -EINVAL;=0A-=0A=
-    fore200e =3D FORE200E_DEV(vcc->dev);=0A-    fore200e_vcc =3D FORE200E_=
VCC(vcc);=0A-=0A-    if (!fore200e)=0A-        return -EINVAL;=0A-=0A-    t=
xq =3D &fore200e->host_txq;=0A-    if (!fore200e_vcc)=0A-        return -EI=
NVAL;=0A+    ASSERT(vcc);=0A+    ASSERT(fore200e);=0A+    ASSERT(fore200e_v=
cc);=0A =0A     if (!test_bit(ATM_VF_READY, &vcc->flags)) {=0A 	DPRINTK(1, =
"VC %d.%d.%d not ready for tx\n", vcc->itf, vcc->vpi, vcc->vpi);=0A-- =0A2.=
30.2=0A=0A=0AFrom fb059003d911c71a03c46213926b80dbc71dc351 Mon Sep 17 00:00=
:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, =
21 Apr 2021 20:26:33 +0100=0ASubject: [PATCH 148/151] Revert "rfkill: Fix i=
ncorrect check to avoid NULL=0A pointer dereference"=0A=0AThis reverts comm=
it 705c7e53702d7eb239b0c27ee0ce20bc44314b6d.=0A=0ACommits from @umn.edu add=
resses have been found to be submitted in "bad=0Afaith" to try to test the =
kernel community's ability to review "known=0Amalicious" changes.  The resu=
lt of these submissions can be found in a=0Apaper published at the 42nd IEE=
E Symposium on Security and Privacy=0Aentitled, "Open Source Insecurity: St=
ealthily Introducing=0AVulnerabilities via Hypocrite Commits" written by Qi=
ushi Wu (University=0Aof Minnesota) and Kangjie Lu (University of Minnesota=
).=0A=0ABecause of this, all submissions from this group must be reverted f=
rom=0Athe kernel tree and will need to be re-reviewed again to determine if=
=0Athey actually are a valid fix.  Until that work is complete, remove this=
=0Achange to ensure that no problems are being introduced into the=0Acodeba=
se.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=
=0A net/rfkill/core.c | 7 ++-----=0A 1 file changed, 2 insertions(+), 5 del=
etions(-)=0A=0Adiff --git a/net/rfkill/core.c b/net/rfkill/core.c=0Aindex 5=
bba7c36ac74..be7b034ebb65 100644=0A--- a/net/rfkill/core.c=0A+++ b/net/rfki=
ll/core.c=0A@@ -1005,13 +1005,10 @@ static void rfkill_sync_work(struct wor=
k_struct *work)=0A int __must_check rfkill_register(struct rfkill *rfkill)=
=0A {=0A 	static unsigned long rfkill_no;=0A-	struct device *dev;=0A+	struc=
t device *dev =3D &rfkill->dev;=0A 	int error;=0A =0A-	if (!rfkill)=0A-		re=
turn -EINVAL;=0A-=0A-	dev =3D &rfkill->dev;=0A+	BUG_ON(!rfkill);=0A =0A 	mu=
tex_lock(&rfkill_global_mutex);=0A =0A-- =0A2.30.2=0A=0A=0AFrom cf0af73dd17=
e112f4783e5271adabb6129ee2575 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukher=
jee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:26:34 +0100=0A=
Subject: [PATCH 149/151] Revert "media: rcar_drif: fix a memory disclosure"=
=0A=0AThis reverts commit 96d7c3cb33c591070d067b048129a4ddd9fb9346.=0A=0ACo=
mmits from @umn.edu addresses have been found to be submitted in "bad=0Afai=
th" to try to test the kernel community's ability to review "known=0Amalici=
ous" changes.  The result of these submissions can be found in a=0Apaper pu=
blished at the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Ope=
n Source Insecurity: Stealthily Introducing=0AVulnerabilities via Hypocrite=
 Commits" written by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (=
University of Minnesota).=0A=0ABecause of this, all submissions from this g=
roup must be reverted from=0Athe kernel tree and will need to be re-reviewe=
d again to determine if=0Athey actually are a valid fix.  Until that work i=
s complete, remove this=0Achange to ensure that no problems are being intro=
duced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukh=
erjee@gmail.com>=0A---=0A drivers/media/platform/rcar_drif.c | 1 -=0A 1 fil=
e changed, 1 deletion(-)=0A=0Adiff --git a/drivers/media/platform/rcar_drif=
=2Ec b/drivers/media/platform/rcar_drif.c=0Aindex af3c8d405509..ae9a5f3e1be=
c 100644=0A--- a/drivers/media/platform/rcar_drif.c=0A+++ b/drivers/media/p=
latform/rcar_drif.c=0A@@ -911,7 +911,6 @@ static int rcar_drif_g_fmt_sdr_ca=
p(struct file *file, void *priv,=0A {=0A 	struct rcar_drif_sdr *sdr =3D vid=
eo_drvdata(file);=0A =0A-	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.=
reserved));=0A 	f->fmt.sdr.pixelformat =3D sdr->fmt->pixelformat;=0A 	f->fm=
t.sdr.buffersize =3D sdr->fmt->buffersize;=0A =0A-- =0A2.30.2=0A=0A=0AFrom =
d29ec1c50a32d762c8861826fa429baf14fa7b82 Mon Sep 17 00:00:00 2001=0AFrom: S=
udip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:26:=
34 +0100=0ASubject: [PATCH 150/151] Revert "drm/gma500: fix memory disclosu=
res due to=0A uninitialized bytes"=0A=0AThis reverts commit 9d1cdde7f629dc6=
e7f2f5a087e844946b022fa7c.=0A=0ACommits from @umn.edu addresses have been f=
ound to be submitted in "bad=0Afaith" to try to test the kernel community's=
 ability to review "known=0Amalicious" changes.  The result of these submis=
sions can be found in a=0Apaper published at the 42nd IEEE Symposium on Sec=
urity and Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introduci=
ng=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu (Universit=
y=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of=
 this, all submissions from this group must be reverted from=0Athe kernel t=
ree and will need to be re-reviewed again to determine if=0Athey actually a=
re a valid fix.  Until that work is complete, remove this=0Achange to ensur=
e that no problems are being introduced into the=0Acodebase.=0A=0ASigned-of=
f-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/gpu/drm=
/gma500/oaktrail_crtc.c | 2 --=0A 1 file changed, 2 deletions(-)=0A=0Adiff =
--git a/drivers/gpu/drm/gma500/oaktrail_crtc.c b/drivers/gpu/drm/gma500/oak=
trail_crtc.c=0Aindex 900e5499249d..167c10767dd4 100644=0A--- a/drivers/gpu/=
drm/gma500/oaktrail_crtc.c=0A+++ b/drivers/gpu/drm/gma500/oaktrail_crtc.c=
=0A@@ -129,7 +129,6 @@ static bool mrst_sdvo_find_best_pll(const struct gma=
_limit_t *limit,=0A 	s32 freq_error, min_error =3D 100000;=0A =0A 	memset(b=
est_clock, 0, sizeof(*best_clock));=0A-	memset(&clock, 0, sizeof(clock));=
=0A =0A 	for (clock.m =3D limit->m.min; clock.m <=3D limit->m.max; clock.m+=
+) {=0A 		for (clock.n =3D limit->n.min; clock.n <=3D limit->n.max;=0A@@ -1=
86,7 +185,6 @@ static bool mrst_lvds_find_best_pll(const struct gma_limit_t=
 *limit,=0A 	int err =3D target;=0A =0A 	memset(best_clock, 0, sizeof(*best=
_clock));=0A-	memset(&clock, 0, sizeof(clock));=0A =0A 	for (clock.m =3D li=
mit->m.min; clock.m <=3D limit->m.max; clock.m++) {=0A 		for (clock.p1 =3D =
limit->p1.min; clock.p1 <=3D limit->p1.max;=0A-- =0A2.30.2=0A=0A=0AFrom 009=
87d39d1b46de457dc7333ef39a3421454b305 Mon Sep 17 00:00:00 2001=0AFrom: Sudi=
p Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:26:34 =
+0100=0ASubject: [PATCH 151/151] Revert "gma/gma500: fix a memory disclosur=
e bug due=0A to uninitialized bytes"=0A=0AThis reverts commit 8b4e9c1bb05a0=
64c456b7937c542e5391c7d6460.=0A=0ACommits from @umn.edu addresses have been=
 found to be submitted in "bad=0Afaith" to try to test the kernel community=
's ability to review "known=0Amalicious" changes.  The result of these subm=
issions can be found in a=0Apaper published at the 42nd IEEE Symposium on S=
ecurity and Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introdu=
cing=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu (Univers=
ity=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause =
of this, all submissions from this group must be reverted from=0Athe kernel=
 tree and will need to be re-reviewed again to determine if=0Athey actually=
 are a valid fix.  Until that work is complete, remove this=0Achange to ens=
ure that no problems are being introduced into the=0Acodebase.=0A=0ASigned-=
off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/gpu/d=
rm/gma500/cdv_intel_display.c | 2 --=0A 1 file changed, 2 deletions(-)=0A=
=0Adiff --git a/drivers/gpu/drm/gma500/cdv_intel_display.c b/drivers/gpu/dr=
m/gma500/cdv_intel_display.c=0Aindex 8b784947ed3b..f56852a503e8 100644=0A--=
- a/drivers/gpu/drm/gma500/cdv_intel_display.c=0A+++ b/drivers/gpu/drm/gma5=
00/cdv_intel_display.c=0A@@ -405,8 +405,6 @@ static bool cdv_intel_find_dp_=
pll(const struct gma_limit_t *limit,=0A 	struct gma_crtc *gma_crtc =3D to_g=
ma_crtc(crtc);=0A 	struct gma_clock_t clock;=0A =0A-	memset(&clock, 0, size=
of(clock));=0A-=0A 	switch (refclk) {=0A 	case 27000:=0A 		if (target < 200=
000) {=0A-- =0A2.30.2=0A=0A
--dKgri1t8WkgmJnuf--
