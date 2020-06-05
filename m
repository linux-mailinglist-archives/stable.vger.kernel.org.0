Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7211EFDF8
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 18:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbgFEQ0H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 12:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726727AbgFEQ0G (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jun 2020 12:26:06 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B55BC08C5C3;
        Fri,  5 Jun 2020 09:26:06 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id n23so5323538pgb.12;
        Fri, 05 Jun 2020 09:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gK4EYEuA1xQYKu5kUOd5FUTkj25yj2mfT5FJcYWK+3k=;
        b=shQeDJbyBfYTp3M9bbw2EB+8hexYYa1PSlBnVP43nt0rnKe1as396LqArd0IxDQ6Kx
         X2QoblKPpYyRtx2kyNF1ApNc4MEfrOOMsm4Ffu/5wK+J2vXH3swUnXAGrafZUcq7HRCo
         FQGyh28SocI1ZS9ut5GCv8ZnO3VdvEPBJbuhY+0ZCKBPsgnvSXSG3s3BpVFC1lQB2fYP
         gajy0Mzz7cPwq++fNj7FeajR6CWOSkmM5TiAlwyqVyBgsO3/n7p2GchbgnLe7/ik1wil
         2wF8yq/qElLaizPlFYiXWADIIBT/uaqg6w06iYW8QOUQn+SCkkB9s3YawHbyld/sSw+r
         zvBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gK4EYEuA1xQYKu5kUOd5FUTkj25yj2mfT5FJcYWK+3k=;
        b=VW7uhwdYZUSCAVr2KzSSzFhcsJcgGccgdmPr5XgwjkvJgl0aZS0Fo5TPuskFY1eoCS
         CYJJlshLlEHxjPB2fmuSwCq7UYUl8K4Y6ScGZabx5OnKrFBJB1jQJkrbcHAFbNhjBC57
         +i3JXN7z5OFbsdVCQUUkYKxt+AoUhPD3SM3rHOzjbZGbaxA1YAmMTbSlAqaSg2tYK/j5
         cJRyxo2iqM9ctrXqXyWxuXpeXTMZTYxM8QwaRlOyEntumvMujqrZD98uqWJ/cQasE1Da
         IJ+W6BvyRpCJMV6NNYBdPxhNFeeQUfYUehObaRhVmM6GN2vhanJsHhsKDlfATfO44llA
         NpCQ==
X-Gm-Message-State: AOAM531xqi4QTcPha1dyjeVraDmCAKd0vOJiudfnHGof9jexO4DSAAMv
        Q4bMp0jZ+CoxbpcikgtBfMTQttWn
X-Google-Smtp-Source: ABdhPJwZzxc3j+7RJHfL1P9YMGbog7zdwEvmseiavKsXgvzzt2iZpzwJXYNICXBcT9a2w5QOQI+v7w==
X-Received: by 2002:a62:8cca:: with SMTP id m193mr6953957pfd.308.1591374364755;
        Fri, 05 Jun 2020 09:26:04 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b29sm86205pff.176.2020.06.05.09.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2020 09:26:03 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
X-Google-Original-From: Florian Fainelli <florian.fainelli@broadcom.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Shuah Khan <shuah@kernel.org>,
        Jaedon Shin <jaedon.shin@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        linux-media@vger.kernel.org (open list:MEDIA INPUT INFRASTRUCTURE
        (V4L/DVB)),
        linux-fsdevel@vger.kernel.org (open list:FILESYSTEMS (VFS and
        infrastructure))
Subject: [PATCH stable 4.9 04/21] media: dvb/frontend.h: document the uAPI file
Date:   Fri,  5 Jun 2020 09:25:01 -0700
Message-Id: <20200605162518.28099-5-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200605162518.28099-1-florian.fainelli@broadcom.com>
References: <20200605162518.28099-1-florian.fainelli@broadcom.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab@s-opensource.com>

commit 8220ead805b6bab4ade2839857a198e9708b07de upstream

Most of the stuff at the Digital TV frontend header file
are documented only at the Documentation. However, a few
kernel-doc markups are there, several of them with parsing
issues.

Add the missing documentation, copying definitions from the
Documentation when it applies, fixing some bugs.

Please notice that DVBv3 stuff that were deprecated weren't
commented by purpose. Instead, they were clearly tagged as
such.

This patch prepares to move part of the documentation from
Documentation/ to kernel-doc comments.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 include/uapi/linux/dvb/frontend.h | 580 +++++++++++++++++++++++++-----
 1 file changed, 498 insertions(+), 82 deletions(-)

diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
index 3a80f3d1da1c..16a318fc469a 100644
--- a/include/uapi/linux/dvb/frontend.h
+++ b/include/uapi/linux/dvb/frontend.h
@@ -28,13 +28,46 @@
 
 #include <linux/types.h>
 
-enum fe_type {
-	FE_QPSK,
-	FE_QAM,
-	FE_OFDM,
-	FE_ATSC
-};
-
+/**
+ * enum fe_caps - Frontend capabilities
+ *
+ * @FE_IS_STUPID:			There's something wrong at the
+ *					frontend, and it can't report its
+ *					capabilities.
+ * @FE_CAN_INVERSION_AUTO:		Can auto-detect frequency spectral
+ *					band inversion
+ * @FE_CAN_FEC_1_2:			Supports FEC 1/2
+ * @FE_CAN_FEC_2_3:			Supports FEC 2/3
+ * @FE_CAN_FEC_3_4:			Supports FEC 3/4
+ * @FE_CAN_FEC_4_5:			Supports FEC 4/5
+ * @FE_CAN_FEC_5_6:			Supports FEC 5/6
+ * @FE_CAN_FEC_6_7:			Supports FEC 6/7
+ * @FE_CAN_FEC_7_8:			Supports FEC 7/8
+ * @FE_CAN_FEC_8_9:			Supports FEC 8/9
+ * @FE_CAN_FEC_AUTO:			Can auto-detect FEC
+ * @FE_CAN_QPSK:			Supports QPSK modulation
+ * @FE_CAN_QAM_16:			Supports 16-QAM modulation
+ * @FE_CAN_QAM_32:			Supports 32-QAM modulation
+ * @FE_CAN_QAM_64:			Supports 64-QAM modulation
+ * @FE_CAN_QAM_128:			Supports 128-QAM modulation
+ * @FE_CAN_QAM_256:			Supports 256-QAM modulation
+ * @FE_CAN_QAM_AUTO:			Can auto-detect QAM modulation
+ * @FE_CAN_TRANSMISSION_MODE_AUTO:	Can auto-detect transmission mode
+ * @FE_CAN_BANDWIDTH_AUTO:		Can auto-detect bandwidth
+ * @FE_CAN_GUARD_INTERVAL_AUTO:		Can auto-detect guard interval
+ * @FE_CAN_HIERARCHY_AUTO:		Can auto-detect hierarchy
+ * @FE_CAN_8VSB:			Supports 8-VSB modulation
+ * @FE_CAN_16VSB:			Supporta 16-VSB modulation
+ * @FE_HAS_EXTENDED_CAPS:		Unused
+ * @FE_CAN_MULTISTREAM:			Supports multistream filtering
+ * @FE_CAN_TURBO_FEC:			Supports "turbo FEC" modulation
+ * @FE_CAN_2G_MODULATION:		Supports "2nd generation" modulation,
+ *					e. g. DVB-S2, DVB-T2, DVB-C2
+ * @FE_NEEDS_BENDING:			Unused
+ * @FE_CAN_RECOVER:			Can recover from a cable unplug
+ *					automatically
+ * @FE_CAN_MUTE_TS:			Can stop spurious TS data output
+ */
 enum fe_caps {
 	FE_IS_STUPID			= 0,
 	FE_CAN_INVERSION_AUTO		= 0x1,
@@ -60,15 +93,55 @@ enum fe_caps {
 	FE_CAN_HIERARCHY_AUTO		= 0x100000,
 	FE_CAN_8VSB			= 0x200000,
 	FE_CAN_16VSB			= 0x400000,
-	FE_HAS_EXTENDED_CAPS		= 0x800000,   /* We need more bitspace for newer APIs, indicate this. */
-	FE_CAN_MULTISTREAM		= 0x4000000,  /* frontend supports multistream filtering */
-	FE_CAN_TURBO_FEC		= 0x8000000,  /* frontend supports "turbo fec modulation" */
-	FE_CAN_2G_MODULATION		= 0x10000000, /* frontend supports "2nd generation modulation" (DVB-S2) */
-	FE_NEEDS_BENDING		= 0x20000000, /* not supported anymore, don't use (frontend requires frequency bending) */
-	FE_CAN_RECOVER			= 0x40000000, /* frontend can recover from a cable unplug automatically */
-	FE_CAN_MUTE_TS			= 0x80000000  /* frontend can stop spurious TS data output */
+	FE_HAS_EXTENDED_CAPS		= 0x800000,
+	FE_CAN_MULTISTREAM		= 0x4000000,
+	FE_CAN_TURBO_FEC		= 0x8000000,
+	FE_CAN_2G_MODULATION		= 0x10000000,
+	FE_NEEDS_BENDING		= 0x20000000,
+	FE_CAN_RECOVER			= 0x40000000,
+	FE_CAN_MUTE_TS			= 0x80000000
+};
+
+/*
+ * DEPRECATED: Should be kept just due to backward compatibility.
+ */
+enum fe_type {
+	FE_QPSK,
+	FE_QAM,
+	FE_OFDM,
+	FE_ATSC
 };
 
+/**
+ * struct dvb_frontend_info - Frontend properties and capabilities
+ *
+ * @name:			Name of the frontend
+ * @type:			**DEPRECATED**.
+ *				Should not be used on modern programs,
+ *				as a frontend may have more than one type.
+ *				In order to get the support types of a given
+ *				frontend, use :c:type:`DTV_ENUM_DELSYS`
+ *				instead.
+ * @frequency_min:		Minimal frequency supported by the frontend.
+ * @frequency_max:		Minimal frequency supported by the frontend.
+ * @frequency_stepsize:		All frequencies are multiple of this value.
+ * @frequency_tolerance:	Frequency tolerance.
+ * @symbol_rate_min:		Minimal symbol rate, in bauds
+ *				(for Cable/Satellite systems).
+ * @symbol_rate_max:		Maximal symbol rate, in bauds
+ *				(for Cable/Satellite systems).
+ * @symbol_rate_tolerance:	Maximal symbol rate tolerance, in ppm
+ *				(for Cable/Satellite systems).
+ * @notifier_delay:		**DEPRECATED**. Not used by any driver.
+ * @caps:			Capabilities supported by the frontend,
+ *				as specified in &enum fe_caps.
+ *
+ * .. note:
+ *
+ *    #. The frequencies are specified in Hz for Terrestrial and Cable
+ *       systems.
+ *    #. The frequencies are specified in kHz for Satellite systems.
+ */
 struct dvb_frontend_info {
 	char       name[128];
 	enum fe_type type;	/* DEPRECATED. Use DTV_ENUM_DELSYS instead */
@@ -78,53 +151,102 @@ struct dvb_frontend_info {
 	__u32      frequency_tolerance;
 	__u32      symbol_rate_min;
 	__u32      symbol_rate_max;
-	__u32      symbol_rate_tolerance;	/* ppm */
+	__u32      symbol_rate_tolerance;
 	__u32      notifier_delay;		/* DEPRECATED */
 	enum fe_caps caps;
 };
 
-
 /**
- *  Check out the DiSEqC bus spec available on http://www.eutelsat.org/ for
- *  the meaning of this struct...
+ * struct dvb_diseqc_master_cmd - DiSEqC master command
+ *
+ * @msg:
+ *	DiSEqC message to be sent. It contains a 3 bytes header with:
+ *	framing + address + command, and an optional argument
+ *	of up to 3 bytes of data.
+ * @msg_len:
+ *	Length of the DiSEqC message. Valid values are 3 to 6.
+ *
+ * Check out the DiSEqC bus spec available on http://www.eutelsat.org/ for
+ * the possible messages that can be used.
  */
 struct dvb_diseqc_master_cmd {
-	__u8 msg [6];	/*  { framing, address, command, data [3] } */
-	__u8 msg_len;	/*  valid values are 3...6  */
+	__u8 msg[6];
+	__u8 msg_len;
 };
 
+/**
+ * struct dvb_diseqc_slave_reply - DiSEqC received data
+ *
+ * @msg:
+ *	DiSEqC message buffer to store a message received via DiSEqC.
+ *	It contains one byte header with: framing and
+ *	an optional argument of up to 3 bytes of data.
+ * @msg_len:
+ *	Length of the DiSEqC message. Valid values are 0 to 4,
+ *	where 0 means no message.
+ * @timeout:
+ *	Return from ioctl after timeout ms with errorcode when
+ *	no message was received.
+ *
+ * Check out the DiSEqC bus spec available on http://www.eutelsat.org/ for
+ * the possible messages that can be used.
+ */
 struct dvb_diseqc_slave_reply {
-	__u8 msg [4];	/*  { framing, data [3] } */
-	__u8 msg_len;	/*  valid values are 0...4, 0 means no msg  */
-	int  timeout;	/*  return from ioctl after timeout ms with */
-};			/*  errorcode when no message was received  */
+	__u8 msg[4];
+	__u8 msg_len;
+	int  timeout;
+};
 
+/**
+ * enum fe_sec_voltage - DC Voltage used to feed the LNBf
+ *
+ * @SEC_VOLTAGE_13:	Output 13V to the LNBf
+ * @SEC_VOLTAGE_18:	Output 18V to the LNBf
+ * @SEC_VOLTAGE_OFF:	Don't feed the LNBf with a DC voltage
+ */
 enum fe_sec_voltage {
 	SEC_VOLTAGE_13,
 	SEC_VOLTAGE_18,
 	SEC_VOLTAGE_OFF
 };
 
+/**
+ * enum fe_sec_tone_mode - Type of tone to be send to the LNBf.
+ * @SEC_TONE_ON:	Sends a 22kHz tone burst to the antenna.
+ * @SEC_TONE_OFF:	Don't send a 22kHz tone to the antenna (except
+ *			if the ``FE_DISEQC_*`` ioctls are called).
+ */
 enum fe_sec_tone_mode {
 	SEC_TONE_ON,
 	SEC_TONE_OFF
 };
 
+/**
+ * enum fe_sec_mini_cmd - Type of mini burst to be sent
+ *
+ * @SEC_MINI_A:		Sends a mini-DiSEqC 22kHz '0' Tone Burst to select
+ *			satellite-A
+ * @SEC_MINI_B:		Sends a mini-DiSEqC 22kHz '1' Data Burst to select
+ *			satellite-B
+ */
 enum fe_sec_mini_cmd {
 	SEC_MINI_A,
 	SEC_MINI_B
 };
 
 /**
- * enum fe_status - enumerates the possible frontend status
- * @FE_HAS_SIGNAL:	found something above the noise level
- * @FE_HAS_CARRIER:	found a DVB signal
- * @FE_HAS_VITERBI:	FEC is stable
- * @FE_HAS_SYNC:	found sync bytes
- * @FE_HAS_LOCK:	everything's working
- * @FE_TIMEDOUT:	no lock within the last ~2 seconds
- * @FE_REINIT:		frontend was reinitialized, application is recommended
- *			to reset DiSEqC, tone and parameters
+ * enum fe_status - Enumerates the possible frontend status.
+ * @FE_NONE:		The frontend doesn't have any kind of lock.
+ *			That's the initial frontend status
+ * @FE_HAS_SIGNAL:	Has found something above the noise level.
+ * @FE_HAS_CARRIER:	Has found a DVB signal.
+ * @FE_HAS_VITERBI:	FEC inner coding (Viterbi, LDPC or other inner code).
+ *			is stable.
+ * @FE_HAS_SYNC:	Synchronization bytes was found.
+ * @FE_HAS_LOCK:	DVB were locked and everything is working.
+ * @FE_TIMEDOUT:	Fo lock within the last about 2 seconds.
+ * @FE_REINIT:		Frontend was reinitialized, application is recommended
+ *			to reset DiSEqC, tone and parameters.
  */
 enum fe_status {
 	FE_NONE			= 0x00,
@@ -137,12 +259,45 @@ enum fe_status {
 	FE_REINIT		= 0x40,
 };
 
+/**
+ * enum fe_spectral_inversion - Type of inversion band
+ *
+ * @INVERSION_OFF:	Don't do spectral band inversion.
+ * @INVERSION_ON:	Do spectral band inversion.
+ * @INVERSION_AUTO:	Autodetect spectral band inversion.
+ *
+ * This parameter indicates if spectral inversion should be presumed or
+ * not. In the automatic setting (``INVERSION_AUTO``) the hardware will try
+ * to figure out the correct setting by itself. If the hardware doesn't
+ * support, the DVB core will try to lock at the carrier first with
+ * inversion off. If it fails, it will try to enable inversion.
+ */
 enum fe_spectral_inversion {
 	INVERSION_OFF,
 	INVERSION_ON,
 	INVERSION_AUTO
 };
 
+/**
+ * enum fe_code_rate - Type of Forward Error Correction (FEC)
+ *
+ *
+ * @FEC_NONE: No Forward Error Correction Code
+ * @FEC_1_2:  Forward Error Correction Code 1/2
+ * @FEC_2_3:  Forward Error Correction Code 2/3
+ * @FEC_3_4:  Forward Error Correction Code 3/4
+ * @FEC_4_5:  Forward Error Correction Code 4/5
+ * @FEC_5_6:  Forward Error Correction Code 5/6
+ * @FEC_6_7:  Forward Error Correction Code 6/7
+ * @FEC_7_8:  Forward Error Correction Code 7/8
+ * @FEC_8_9:  Forward Error Correction Code 8/9
+ * @FEC_AUTO: Autodetect Error Correction Code
+ * @FEC_3_5:  Forward Error Correction Code 3/5
+ * @FEC_9_10: Forward Error Correction Code 9/10
+ * @FEC_2_5:  Forward Error Correction Code 2/5
+ *
+ * Please note that not all FEC types are supported by a given standard.
+ */
 enum fe_code_rate {
 	FEC_NONE = 0,
 	FEC_1_2,
@@ -159,6 +314,26 @@ enum fe_code_rate {
 	FEC_2_5,
 };
 
+/**
+ * enum fe_modulation - Type of modulation/constellation
+ * @QPSK:	QPSK modulation
+ * @QAM_16:	16-QAM modulation
+ * @QAM_32:	32-QAM modulation
+ * @QAM_64:	64-QAM modulation
+ * @QAM_128:	128-QAM modulation
+ * @QAM_256:	256-QAM modulation
+ * @QAM_AUTO:	Autodetect QAM modulation
+ * @VSB_8:	8-VSB modulation
+ * @VSB_16:	16-VSB modulation
+ * @PSK_8:	8-PSK modulation
+ * @APSK_16:	16-APSK modulation
+ * @APSK_32:	32-APSK modulation
+ * @DQPSK:	DQPSK modulation
+ * @QAM_4_NR:	4-QAM-NR modulation
+ *
+ * Please note that not all modulations are supported by a given standard.
+ *
+ */
 enum fe_modulation {
 	QPSK,
 	QAM_16,
@@ -176,6 +351,32 @@ enum fe_modulation {
 	QAM_4_NR,
 };
 
+/**
+ * enum fe_transmit_mode - Transmission mode
+ *
+ * @TRANSMISSION_MODE_AUTO:
+ *	Autodetect transmission mode. The hardware will try to find the
+ *	correct FFT-size (if capable) to fill in the missing parameters.
+ * @TRANSMISSION_MODE_1K:
+ *	Transmission mode 1K
+ * @TRANSMISSION_MODE_2K:
+ *	Transmission mode 2K
+ * @TRANSMISSION_MODE_8K:
+ *	Transmission mode 8K
+ * @TRANSMISSION_MODE_4K:
+ *	Transmission mode 4K
+ * @TRANSMISSION_MODE_16K:
+ *	Transmission mode 16K
+ * @TRANSMISSION_MODE_32K:
+ *	Transmission mode 32K
+ * @TRANSMISSION_MODE_C1:
+ *	Single Carrier (C=1) transmission mode (DTMB only)
+ * @TRANSMISSION_MODE_C3780:
+ *	Multi Carrier (C=3780) transmission mode (DTMB only)
+ *
+ * Please note that not all transmission modes are supported by a given
+ * standard.
+ */
 enum fe_transmit_mode {
 	TRANSMISSION_MODE_2K,
 	TRANSMISSION_MODE_8K,
@@ -188,6 +389,23 @@ enum fe_transmit_mode {
 	TRANSMISSION_MODE_C3780,
 };
 
+/**
+ * enum fe_guard_interval - Guard interval
+ *
+ * @GUARD_INTERVAL_AUTO:	Autodetect the guard interval
+ * @GUARD_INTERVAL_1_128:	Guard interval 1/128
+ * @GUARD_INTERVAL_1_32:	Guard interval 1/32
+ * @GUARD_INTERVAL_1_16:	Guard interval 1/16
+ * @GUARD_INTERVAL_1_8:		Guard interval 1/8
+ * @GUARD_INTERVAL_1_4:		Guard interval 1/4
+ * @GUARD_INTERVAL_19_128:	Guard interval 19/128
+ * @GUARD_INTERVAL_19_256:	Guard interval 19/256
+ * @GUARD_INTERVAL_PN420:	PN length 420 (1/4)
+ * @GUARD_INTERVAL_PN595:	PN length 595 (1/6)
+ * @GUARD_INTERVAL_PN945:	PN length 945 (1/9)
+ *
+ * Please note that not all guard intervals are supported by a given standard.
+ */
 enum fe_guard_interval {
 	GUARD_INTERVAL_1_32,
 	GUARD_INTERVAL_1_16,
@@ -202,6 +420,16 @@ enum fe_guard_interval {
 	GUARD_INTERVAL_PN945,
 };
 
+/**
+ * enum fe_hierarchy - Hierarchy
+ * @HIERARCHY_NONE:	No hierarchy
+ * @HIERARCHY_AUTO:	Autodetect hierarchy (if supported)
+ * @HIERARCHY_1:	Hierarchy 1
+ * @HIERARCHY_2:	Hierarchy 2
+ * @HIERARCHY_4:	Hierarchy 4
+ *
+ * Please note that not all hierarchy types are supported by a given standard.
+ */
 enum fe_hierarchy {
 	HIERARCHY_NONE,
 	HIERARCHY_1,
@@ -210,6 +438,15 @@ enum fe_hierarchy {
 	HIERARCHY_AUTO
 };
 
+/**
+ * enum fe_interleaving - Interleaving
+ * @INTERLEAVING_NONE:	No interleaving.
+ * @INTERLEAVING_AUTO:	Auto-detect interleaving.
+ * @INTERLEAVING_240:	Interleaving of 240 symbols.
+ * @INTERLEAVING_720:	Interleaving of 720 symbols.
+ *
+ * Please note that, currently, only DTMB uses it.
+ */
 enum fe_interleaving {
 	INTERLEAVING_NONE,
 	INTERLEAVING_AUTO,
@@ -217,7 +454,8 @@ enum fe_interleaving {
 	INTERLEAVING_720,
 };
 
-/* S2API Commands */
+/* DVBv5 property Commands */
+
 #define DTV_UNDEFINED		0
 #define DTV_TUNE		1
 #define DTV_CLEAR		2
@@ -310,19 +548,79 @@ enum fe_interleaving {
 
 #define DTV_MAX_COMMAND		DTV_STAT_TOTAL_BLOCK_COUNT
 
+/**
+ * enum fe_pilot - Type of pilot tone
+ *
+ * @PILOT_ON:	Pilot tones enabled
+ * @PILOT_OFF:	Pilot tones disabled
+ * @PILOT_AUTO:	Autodetect pilot tones
+ */
 enum fe_pilot {
 	PILOT_ON,
 	PILOT_OFF,
 	PILOT_AUTO,
 };
 
+/**
+ * enum fe_rolloff - Rolloff factor (also known as alpha)
+ * @ROLLOFF_35:		Roloff factor: 35%
+ * @ROLLOFF_20:		Roloff factor: 20%
+ * @ROLLOFF_25:		Roloff factor: 25%
+ * @ROLLOFF_AUTO:	Auto-detect the roloff factor.
+ *
+ * .. note:
+ *
+ *    Roloff factor of 35% is implied on DVB-S. On DVB-S2, it is default.
+ */
 enum fe_rolloff {
-	ROLLOFF_35, /* Implied value in DVB-S, default for DVB-S2 */
+	ROLLOFF_35,
 	ROLLOFF_20,
 	ROLLOFF_25,
 	ROLLOFF_AUTO,
 };
 
+/**
+ * enum fe_delivery_system - Type of the delivery system
+ *
+ * @SYS_UNDEFINED:
+ *	Undefined standard. Generally, indicates an error
+ * @SYS_DVBC_ANNEX_A:
+ *	Cable TV: DVB-C following ITU-T J.83 Annex A spec
+ * @SYS_DVBC_ANNEX_B:
+ *	Cable TV: DVB-C following ITU-T J.83 Annex B spec (ClearQAM)
+ * @SYS_DVBC_ANNEX_C:
+ *	Cable TV: DVB-C following ITU-T J.83 Annex C spec
+ * @SYS_ISDBC:
+ *	Cable TV: ISDB-C (no drivers yet)
+ * @SYS_DVBT:
+ *	Terrestrial TV: DVB-T
+ * @SYS_DVBT2:
+ *	Terrestrial TV: DVB-T2
+ * @SYS_ISDBT:
+ *	Terrestrial TV: ISDB-T
+ * @SYS_ATSC:
+ *	Terrestrial TV: ATSC
+ * @SYS_ATSCMH:
+ *	Terrestrial TV (mobile): ATSC-M/H
+ * @SYS_DTMB:
+ *	Terrestrial TV: DTMB
+ * @SYS_DVBS:
+ *	Satellite TV: DVB-S
+ * @SYS_DVBS2:
+ *	Satellite TV: DVB-S2
+ * @SYS_TURBO:
+ *	Satellite TV: DVB-S Turbo
+ * @SYS_ISDBS:
+ *	Satellite TV: ISDB-S
+ * @SYS_DAB:
+ *	Digital audio: DAB (not fully supported)
+ * @SYS_DSS:
+ *	Satellite TV: DSS (not fully supported)
+ * @SYS_CMMB:
+ *	Terrestrial TV (mobile): CMMB (not fully supported)
+ * @SYS_DVBH:
+ *	Terrestrial TV (mobile): DVB-H (standard deprecated)
+ */
 enum fe_delivery_system {
 	SYS_UNDEFINED,
 	SYS_DVBC_ANNEX_A,
@@ -345,35 +643,85 @@ enum fe_delivery_system {
 	SYS_DVBC_ANNEX_C,
 };
 
-/* backward compatibility */
+/* backward compatibility definitions for delivery systems */
 #define SYS_DVBC_ANNEX_AC	SYS_DVBC_ANNEX_A
-#define SYS_DMBTH SYS_DTMB /* DMB-TH is legacy name, use DTMB instead */
+#define SYS_DMBTH		SYS_DTMB /* DMB-TH is legacy name, use DTMB */
 
-/* ATSC-MH */
+/* ATSC-MH specific parameters */
 
+/**
+ * enum atscmh_sccc_block_mode - Type of Series Concatenated Convolutional
+ *				 Code Block Mode.
+ *
+ * @ATSCMH_SCCC_BLK_SEP:
+ *	Separate SCCC: the SCCC outer code mode shall be set independently
+ *	for each Group Region (A, B, C, D)
+ * @ATSCMH_SCCC_BLK_COMB:
+ *	Combined SCCC: all four Regions shall have the same SCCC outer
+ *	code mode.
+ * @ATSCMH_SCCC_BLK_RES:
+ *	Reserved. Shouldn't be used.
+ */
 enum atscmh_sccc_block_mode {
 	ATSCMH_SCCC_BLK_SEP      = 0,
 	ATSCMH_SCCC_BLK_COMB     = 1,
 	ATSCMH_SCCC_BLK_RES      = 2,
 };
 
+/**
+ * enum atscmh_sccc_code_mode - Type of Series Concatenated Convolutional
+ *				Code Rate.
+ *
+ * @ATSCMH_SCCC_CODE_HLF:
+ *	The outer code rate of a SCCC Block is 1/2 rate.
+ * @ATSCMH_SCCC_CODE_QTR:
+ *	The outer code rate of a SCCC Block is 1/4 rate.
+ * @ATSCMH_SCCC_CODE_RES:
+ *	Reserved. Should not be used.
+ */
 enum atscmh_sccc_code_mode {
 	ATSCMH_SCCC_CODE_HLF     = 0,
 	ATSCMH_SCCC_CODE_QTR     = 1,
 	ATSCMH_SCCC_CODE_RES     = 2,
 };
 
+/**
+ * enum atscmh_rs_frame_ensemble - Reed Solomon(RS) frame ensemble.
+ *
+ * @ATSCMH_RSFRAME_ENS_PRI:	Primary Ensemble.
+ * @ATSCMH_RSFRAME_ENS_SEC:	Secondary Ensemble.
+ */
 enum atscmh_rs_frame_ensemble {
 	ATSCMH_RSFRAME_ENS_PRI   = 0,
 	ATSCMH_RSFRAME_ENS_SEC   = 1,
 };
 
+/**
+ * enum atscmh_rs_frame_mode - Reed Solomon (RS) frame mode.
+ *
+ * @ATSCMH_RSFRAME_PRI_ONLY:
+ *	Single Frame: There is only a primary RS Frame for all Group
+ *	Regions.
+ * @ATSCMH_RSFRAME_PRI_SEC:
+ *	Dual Frame: There are two separate RS Frames: Primary RS Frame for
+ *	Group Region A and B and Secondary RS Frame for Group Region C and
+ *	D.
+ * @ATSCMH_RSFRAME_RES:
+ *	Reserved. Shouldn't be used.
+ */
 enum atscmh_rs_frame_mode {
 	ATSCMH_RSFRAME_PRI_ONLY  = 0,
 	ATSCMH_RSFRAME_PRI_SEC   = 1,
 	ATSCMH_RSFRAME_RES       = 2,
 };
 
+/**
+ * enum atscmh_rs_code_mode
+ * @ATSCMH_RSCODE_211_187:	Reed Solomon code (211,187).
+ * @ATSCMH_RSCODE_223_187:	Reed Solomon code (223,187).
+ * @ATSCMH_RSCODE_235_187:	Reed Solomon code (235,187).
+ * @ATSCMH_RSCODE_RES:		Reserved. Shouldn't be used.
+ */
 enum atscmh_rs_code_mode {
 	ATSCMH_RSCODE_211_187    = 0,
 	ATSCMH_RSCODE_223_187    = 1,
@@ -385,16 +733,17 @@ enum atscmh_rs_code_mode {
 #define LNA_AUTO                (~0U)
 
 /**
- * Scale types for the quality parameters.
+ * enum fecap_scale_params - scale types for the quality parameters.
+ *
  * @FE_SCALE_NOT_AVAILABLE: That QoS measure is not available. That
  *			    could indicate a temporary or a permanent
  *			    condition.
  * @FE_SCALE_DECIBEL: The scale is measured in 0.001 dB steps, typically
- *		  used on signal measures.
+ *		      used on signal measures.
  * @FE_SCALE_RELATIVE: The scale is a relative percentual measure,
- *			ranging from 0 (0%) to 0xffff (100%).
+ *		       ranging from 0 (0%) to 0xffff (100%).
  * @FE_SCALE_COUNTER: The scale counts the occurrence of an event, like
- *			bit error, block error, lapsed time.
+ *		      bit error, block error, lapsed time.
  */
 enum fecap_scale_params {
 	FE_SCALE_NOT_AVAILABLE = 0,
@@ -406,24 +755,38 @@ enum fecap_scale_params {
 /**
  * struct dtv_stats - Used for reading a DTV status property
  *
- * @value:	value of the measure. Should range from 0 to 0xffff;
  * @scale:	Filled with enum fecap_scale_params - the scale
  *		in usage for that parameter
  *
+ * The ``{unnamed_union}`` may have either one of the values below:
+ *
+ * %svalue
+ *	integer value of the measure, for %FE_SCALE_DECIBEL,
+ *	used for dB measures. The unit is 0.001 dB.
+ *
+ * %uvalue
+ *	unsigned integer value of the measure, used when @scale is
+ *	either %FE_SCALE_RELATIVE or %FE_SCALE_COUNTER.
+ *
  * For most delivery systems, this will return a single value for each
  * parameter.
+ *
  * It should be noticed, however, that new OFDM delivery systems like
  * ISDB can use different modulation types for each group of carriers.
  * On such standards, up to 8 groups of statistics can be provided, one
  * for each carrier group (called "layer" on ISDB).
+ *
  * In order to be consistent with other delivery systems, the first
  * value refers to the entire set of carriers ("global").
- * dtv_status:scale should use the value FE_SCALE_NOT_AVAILABLE when
+ *
+ * @scale should use the value %FE_SCALE_NOT_AVAILABLE when
  * the value for the entire group of carriers or from one specific layer
  * is not provided by the hardware.
- * st.len should be filled with the latest filled status + 1.
  *
- * In other words, for ISDB, those values should be filled like:
+ * @len should be filled with the latest filled status + 1.
+ *
+ * In other words, for ISDB, those values should be filled like::
+ *
  *	u.st.stat.svalue[0] = global statistics;
  *	u.st.stat.scale[0] = FE_SCALE_DECIBEL;
  *	u.st.stat.value[1] = layer A statistics;
@@ -445,11 +808,39 @@ struct dtv_stats {
 
 #define MAX_DTV_STATS   4
 
+/**
+ * struct dtv_fe_stats - store Digital TV frontend statistics
+ *
+ * @len:	length of the statistics - if zero, stats is disabled.
+ * @stat:	array with digital TV statistics.
+ *
+ * On most standards, @len can either be 0 or 1. However, for ISDB, each
+ * layer is modulated in separate. So, each layer may have its own set
+ * of statistics. If so, stat[0] carries on a global value for the property.
+ * Indexes 1 to 3 means layer A to B.
+ */
 struct dtv_fe_stats {
 	__u8 len;
 	struct dtv_stats stat[MAX_DTV_STATS];
 } __attribute__ ((packed));
 
+/**
+ * struct dtv_property - store one of frontend command and its value
+ *
+ * @cmd:	Digital TV command.
+ * @reserved:	Not used.
+ * @u:		Union with the values for the command.
+ * @result:	Result of the command set (currently unused).
+ *
+ * The @u union may have either one of the values below:
+ *
+ * %data
+ *	an unsigned 32-bits number.
+ * %st
+ *	a &struct dtv_fe_stats array of statistics.
+ * %buffer
+ *	a buffer of up to 32 characters (currently unused).
+ */
 struct dtv_property {
 	__u32 cmd;
 	__u32 reserved[3];
@@ -469,17 +860,70 @@ struct dtv_property {
 /* num of properties cannot exceed DTV_IOCTL_MAX_MSGS per ioctl */
 #define DTV_IOCTL_MAX_MSGS 64
 
+/**
+ * struct dtv_properties - a set of command/value pairs.
+ *
+ * @num:	amount of commands stored at the struct.
+ * @props:	a pointer to &struct dtv_property.
+ */
 struct dtv_properties {
 	__u32 num;
 	struct dtv_property *props;
 };
 
+/*
+ * When set, this flag will disable any zigzagging or other "normal" tuning
+ * behavior. Additionally, there will be no automatic monitoring of the lock
+ * status, and hence no frontend events will be generated. If a frontend device
+ * is closed, this flag will be automatically turned off when the device is
+ * reopened read-write.
+ */
+#define FE_TUNE_MODE_ONESHOT 0x01
+
+/* Digital TV Frontend API calls */
+
+#define FE_GET_INFO		   _IOR('o', 61, struct dvb_frontend_info)
+
+#define FE_DISEQC_RESET_OVERLOAD   _IO('o', 62)
+#define FE_DISEQC_SEND_MASTER_CMD  _IOW('o', 63, struct dvb_diseqc_master_cmd)
+#define FE_DISEQC_RECV_SLAVE_REPLY _IOR('o', 64, struct dvb_diseqc_slave_reply)
+#define FE_DISEQC_SEND_BURST       _IO('o', 65)  /* fe_sec_mini_cmd_t */
+
+#define FE_SET_TONE		   _IO('o', 66)  /* fe_sec_tone_mode_t */
+#define FE_SET_VOLTAGE		   _IO('o', 67)  /* fe_sec_voltage_t */
+#define FE_ENABLE_HIGH_LNB_VOLTAGE _IO('o', 68)  /* int */
+
+#define FE_READ_STATUS		   _IOR('o', 69, fe_status_t)
+#define FE_READ_BER		   _IOR('o', 70, __u32)
+#define FE_READ_SIGNAL_STRENGTH    _IOR('o', 71, __u16)
+#define FE_READ_SNR		   _IOR('o', 72, __u16)
+#define FE_READ_UNCORRECTED_BLOCKS _IOR('o', 73, __u32)
+
+#define FE_SET_FRONTEND_TUNE_MODE  _IO('o', 81) /* unsigned int */
+#define FE_GET_EVENT		   _IOR('o', 78, struct dvb_frontend_event)
+
+#define FE_DISHNETWORK_SEND_LEGACY_CMD _IO('o', 80) /* unsigned int */
+
+#define FE_SET_PROPERTY		   _IOW('o', 82, struct dtv_properties)
+#define FE_GET_PROPERTY		   _IOR('o', 83, struct dtv_properties)
+
 #if defined(__DVB_CORE__) || !defined (__KERNEL__)
 
 /*
- * DEPRECATED: The DVBv3 ioctls, structs and enums should not be used on
- * newer programs, as it doesn't support the second generation of digital
- * TV standards, nor supports newer delivery systems.
+ * DEPRECATED: Everything below is deprecated in favor of DVBv5 API
+ *
+ * The DVBv3 only ioctls, structs and enums should not be used on
+ * newer programs, as it doesn't support the second generation of
+ * digital TV standards, nor supports newer delivery systems.
+ * They also don't support modern frontends with usually support multiple
+ * delivery systems.
+ *
+ * Drivers shouldn't use them.
+ *
+ * New applications should use DVBv5 delivery system instead
+ */
+
+/*
  */
 
 enum fe_bandwidth {
@@ -492,7 +936,7 @@ enum fe_bandwidth {
 	BANDWIDTH_1_712_MHZ,
 };
 
-/* This is needed for legacy userspace support */
+/* This is kept for legacy userspace support */
 typedef enum fe_sec_voltage fe_sec_voltage_t;
 typedef enum fe_caps fe_caps_t;
 typedef enum fe_type fe_type_t;
@@ -510,6 +954,8 @@ typedef enum fe_pilot fe_pilot_t;
 typedef enum fe_rolloff fe_rolloff_t;
 typedef enum fe_delivery_system fe_delivery_system_t;
 
+/* DVBv3 structs */
+
 struct dvb_qpsk_parameters {
 	__u32		symbol_rate;  /* symbol rate in Symbols per second */
 	fe_code_rate_t	fec_inner;    /* forward error correction (see above) */
@@ -551,42 +997,12 @@ struct dvb_frontend_event {
 	fe_status_t status;
 	struct dvb_frontend_parameters parameters;
 };
-#endif
-
-#define FE_SET_PROPERTY		   _IOW('o', 82, struct dtv_properties)
-#define FE_GET_PROPERTY		   _IOR('o', 83, struct dtv_properties)
-
-/**
- * When set, this flag will disable any zigzagging or other "normal" tuning
- * behaviour. Additionally, there will be no automatic monitoring of the lock
- * status, and hence no frontend events will be generated. If a frontend device
- * is closed, this flag will be automatically turned off when the device is
- * reopened read-write.
- */
-#define FE_TUNE_MODE_ONESHOT 0x01
 
-#define FE_GET_INFO		   _IOR('o', 61, struct dvb_frontend_info)
-
-#define FE_DISEQC_RESET_OVERLOAD   _IO('o', 62)
-#define FE_DISEQC_SEND_MASTER_CMD  _IOW('o', 63, struct dvb_diseqc_master_cmd)
-#define FE_DISEQC_RECV_SLAVE_REPLY _IOR('o', 64, struct dvb_diseqc_slave_reply)
-#define FE_DISEQC_SEND_BURST       _IO('o', 65)  /* fe_sec_mini_cmd_t */
-
-#define FE_SET_TONE		   _IO('o', 66)  /* fe_sec_tone_mode_t */
-#define FE_SET_VOLTAGE		   _IO('o', 67)  /* fe_sec_voltage_t */
-#define FE_ENABLE_HIGH_LNB_VOLTAGE _IO('o', 68)  /* int */
-
-#define FE_READ_STATUS		   _IOR('o', 69, fe_status_t)
-#define FE_READ_BER		   _IOR('o', 70, __u32)
-#define FE_READ_SIGNAL_STRENGTH    _IOR('o', 71, __u16)
-#define FE_READ_SNR		   _IOR('o', 72, __u16)
-#define FE_READ_UNCORRECTED_BLOCKS _IOR('o', 73, __u32)
+/* DVBv3 API calls */
 
 #define FE_SET_FRONTEND		   _IOW('o', 76, struct dvb_frontend_parameters)
 #define FE_GET_FRONTEND		   _IOR('o', 77, struct dvb_frontend_parameters)
-#define FE_SET_FRONTEND_TUNE_MODE  _IO('o', 81) /* unsigned int */
-#define FE_GET_EVENT		   _IOR('o', 78, struct dvb_frontend_event)
 
-#define FE_DISHNETWORK_SEND_LEGACY_CMD _IO('o', 80) /* unsigned int */
+#endif
 
 #endif /*_DVBFRONTEND_H_*/
-- 
2.17.1

