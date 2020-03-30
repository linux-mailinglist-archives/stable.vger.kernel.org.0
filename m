Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 972E5198096
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 18:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729999AbgC3QJ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 12:09:56 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:38092 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727890AbgC3QJz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Mar 2020 12:09:55 -0400
Received: by mail-qk1-f196.google.com with SMTP id h14so19565564qke.5;
        Mon, 30 Mar 2020 09:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ohib3hnvhTod3CZIQWWiioagJ6kp3uz7wDiAesDBzkM=;
        b=YNpUP9D/d4OHlINQKGfnWi+UaXtSzqvZpt2emvh2T8UoDe7h1pH5gbILEj9sj7wkgA
         Rh61JdMkMtWbRIsDDQKvIqx1+YZ1VJtAfjOu0px+X4An7tHEy0R0fg7lGwLMcMhyVBVV
         LxQHkV910qJn1VKWsaxUp3jZ2AmEE7lQSBqiEFYoxDU3oWHIj4q7Stbx4k/kdCx2x8Ur
         hE+iA2Bwgts4iaY80CoaQhrvQaE2mbBDQ+TARMo3jXj5eaAj2Ch+Ma2wYmDslhXnk2AR
         DmnD7bg22/gSmRiximxJZcw+aueQW8pcplX56jOk+79yKpCWexA4MbYRpuRDX4gh6Sgi
         0F3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ohib3hnvhTod3CZIQWWiioagJ6kp3uz7wDiAesDBzkM=;
        b=hRXrF/Z+Nc3YeS3ry3iCGebSl6h/04uMRWFk/d2CaXu0odAk3DpjFuSbiFW9z7a3Uq
         za8yhWNGp0aDEv3Qib+yEMDuLVyG8I9eMeXEFt06y4OpD+SxC3w3E40qqvIdWC7+uE2C
         9FvdUsc88g4F3Leo2y892HaKtq+3eG0PkhxRG1czDJ1YKMaJxIBswsvNdu85ZgbL4Daq
         HxDcKOvzTJgXLiT8qUYjF6J/9PDD1WTG4sKqNU2NQE0OFk+FQt+lwkODXTFzBaVzo8/m
         ccNOu57bRt6E7bBVwm8bSK64e/Qon/MzBXjDefZ4OfLngW3wzsOIyTiKkRAl+OdBK2H6
         vz8Q==
X-Gm-Message-State: ANhLgQ0qJa9dZn0+zEIb79wb4lhbePGIsUH/xwdRl9uekTRchNzUtMbr
        Cc0FDpQn1ILZpK1Y3S/m39denjp+N1gy4g==
X-Google-Smtp-Source: ADFU+vvQQjkV9SdpQcYCGAb6avfom6A6AOZklborzjWFYYlWNF4dTQV40zDe+4SfIRQZyWUUlaeFpg==
X-Received: by 2002:a37:66cf:: with SMTP id a198mr703261qkc.203.1585584593817;
        Mon, 30 Mar 2020 09:09:53 -0700 (PDT)
Received: from stingray.lan (pool-173-76-255-234.bstnma.fios.verizon.net. [173.76.255.234])
        by smtp.gmail.com with ESMTPSA id z18sm11789091qtz.77.2020.03.30.09.09.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 09:09:53 -0700 (PDT)
From:   Thomas Hebb <tommyhebb@gmail.com>
To:     alsa-devel@alsa-project.org
Cc:     linux-kernel@vger.kernel.org, Kailang Yang <kailang@realtek.com>,
        Thomas Hebb <tommyhebb@gmail.com>, stable@vger.kernel.org,
        Jaroslav Kysela <perex@perex.cz>,
        Jonathan Corbet <corbet@lwn.net>,
        Takashi Iwai <tiwai@suse.com>, linux-doc@vger.kernel.org
Subject: [PATCH v2 1/3] ALSA: doc: Document PC Beep Hidden Register on Realtek ALC256
Date:   Mon, 30 Mar 2020 12:09:37 -0400
Message-Id: <bd69dfdeaf40ff31c4b7b797c829bb320031739c.1585584498.git.tommyhebb@gmail.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <cover.1585584498.git.tommyhebb@gmail.com>
References: <cover.1585584498.git.tommyhebb@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This codec (among others) has a hidden set of audio routes, apparently
designed to allow PC Beep output without a mixer widget on the output
path, which are controlled by an undocumented Realtek vendor register.
The default configuration of these routes means that certain inputs
aren't accessible, necessitating driver control of the register.
However, Realtek has provided no documentation of the register, instead
opting to fix issues by providing magic numbers, most of which have been
at least somewhat erroneous. These magic numbers then get copied by
others into model-specific fixups, leading to a fragmented and buggy set
of configurations.

To get out of this situation, I've reverse engineered the register by
flipping bits and observing how the codec's behavior changes. This
commit documents my findings. It does not change any code.

Cc: stable@vger.kernel.org
Signed-off-by: Thomas Hebb <tommyhebb@gmail.com>
---

Changes in v2: None

 Documentation/sound/hd-audio/index.rst        |   1 +
 .../sound/hd-audio/realtek-pc-beep.rst        | 129 ++++++++++++++++++
 2 files changed, 130 insertions(+)
 create mode 100644 Documentation/sound/hd-audio/realtek-pc-beep.rst

diff --git a/Documentation/sound/hd-audio/index.rst b/Documentation/sound/hd-audio/index.rst
index f8a72ffffe66..6e12de9fc34e 100644
--- a/Documentation/sound/hd-audio/index.rst
+++ b/Documentation/sound/hd-audio/index.rst
@@ -8,3 +8,4 @@ HD-Audio
    models
    controls
    dp-mst
+   realtek-pc-beep
diff --git a/Documentation/sound/hd-audio/realtek-pc-beep.rst b/Documentation/sound/hd-audio/realtek-pc-beep.rst
new file mode 100644
index 000000000000..be47c6f76a6e
--- /dev/null
+++ b/Documentation/sound/hd-audio/realtek-pc-beep.rst
@@ -0,0 +1,129 @@
+===============================
+Realtek PC Beep Hidden Register
+===============================
+
+This file documents the "PC Beep Hidden Register", which is present in certain
+Realtek HDA codecs and controls a muxer and pair of passthrough mixers that can
+route audio between pins but aren't themselves exposed as HDA widgets. As far
+as I can tell, these hidden routes are designed to allow flexible PC Beep output
+for codecs that don't have mixer widgets in their output paths. Why it's easier
+to hide a mixer behind an undocumented vendor register than to just expose it
+as a widget, I have no idea.
+
+Register Description
+====================
+
+The register is accessed via processing coefficient 0x36 on NID 20h. Bits not
+identified below have no discernible effect on my machine, a Dell XPS 13 9350::
+
+  MSB                           LSB
+  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+  | |h|S|L|         | B |R|       | Known bits
+  +=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+
+  |0|0|1|1|  0x7  |0|0x0|1|  0x7  | Reset value
+  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+
+1Ah input select (B): 2 bits
+  When zero, expose the PC Beep line (from the internal beep generator, when
+  enabled with the Set Beep Generation verb on NID 01h, or else from the
+  external PCBEEP pin) on the 1Ah pin node. When nonzero, expose the headphone
+  jack (or possibly Line In on some machines) input instead. If PC Beep is
+  selected, the 1Ah boost control has no effect.
+
+Amplify 1Ah loopback, left (L): 1 bit
+  Amplify the left channel of 1Ah before mixing it into outputs as specified
+  by h and S bits. Does not affect the level of 1Ah exposed to other widgets.
+
+Amplify 1Ah loopback, right (R): 1 bit
+  Amplify the right channel of 1Ah before mixing it into outputs as specified
+  by h and S bits. Does not affect the level of 1Ah exposed to other widgets.
+
+Loopback 1Ah to 21h [active low] (h): 1 bit
+  When zero, mix 1Ah (possibly with amplification, depending on L and R bits)
+  into 21h (headphone jack on my machine). Mixed signal respects the mute
+  setting on 21h.
+
+Loopback 1Ah to 14h (S): 1 bit
+  When one, mix 1Ah (possibly with amplification, depending on L and R bits)
+  into 14h (internal speaker on my machine). Mixed signal **ignores** the mute
+  setting on 14h and is present whenever 14h is configured as an output.
+
+Path diagrams
+=============
+
+1Ah input selection (DIV is the PC Beep divider set on NID 01h)::
+
+  <Beep generator>   <PCBEEP pin>    <Headphone jack>
+          |                |                |
+          +--DIV--+--!DIV--+       {1Ah boost control}
+                  |                         |
+                  +--(b == 0)--+--(b != 0)--+
+                               |
+               >1Ah (Beep/Headphone Mic/Line In)<
+
+Loopback of 1Ah to 21h/14h::
+
+               <1Ah (Beep/Headphone Mic/Line In)>
+                               |
+                        {amplify if L/R}
+                               |
+                  +-----!h-----+-----S-----+
+                  |                        |
+          {21h mute control}               |
+                  |                        |
+          >21h (Headphone)<     >14h (Internal Speaker)<
+
+Background
+==========
+
+All Realtek HDA codecs have a vendor-defined widget with node ID 20h which
+provides access to a bank of registers that control various codec functions.
+Registers are read and written via the standard HDA processing coefficient
+verbs (Set/Get Coefficient Index, Set/Get Processing Coefficient). The node is
+named "Realtek Vendor Registers" in public datasheets' verb listings and,
+apart from that, is entirely undocumented.
+
+This particular register, exposed at coefficient 0x36 and named in commits from
+Realtek, is of note: unlike most registers, which seem to control detailed
+amplifier parameters not in scope of the HDA specification, it controls audio
+routing which could just as easily have been defined using standard HDA mixer
+and selector widgets.
+
+Specifically, it selects between two sources for the input pin widget with Node
+ID (NID) 1Ah: the widget's signal can come either from an audio jack (on my
+laptop, a Dell XPS 13 9350, it's the headphone jack, but comments in Realtek
+commits indicate that it might be a Line In on some machines) or from the PC
+Beep line (which is itself multiplexed between the codec's internal beep
+generator and external PCBEEP pin, depending on if the beep generator is
+enabled via verbs on NID 01h). Additionally, it can mix (with optional
+amplification) that signal onto the 21h and/or 14h output pins.
+
+The register's reset value is 0x3717, corresponding to PC Beep on 1Ah that is
+then amplified and mixed into both the headphones and the speakers. Not only
+does this violate the HDA specification, which says that "[a vendor defined
+beep input pin] connection may be maintained *only* while the Link reset
+(**RST#**) is asserted", it means that we cannot ignore the register if we care
+about the input that 1Ah would otherwise expose or if the PCBEEP trace is
+poorly shielded and picks up chassis noise (both of which are the case on my
+machine).
+
+Unfortunately, there are lots of ways to get this register configuration wrong.
+Linux, it seems, has gone through most of them. For one, the register resets
+after S3 suspend: judging by existing code, this isn't the case for all vendor
+registers, and it's led to some fixes that improve behavior on cold boot but
+don't last after suspend. Other fixes have successfully switched the 1Ah input
+away from PC Beep but have failed to disable both loopback paths. On my
+machine, this means that the headphone input is amplified and looped back to
+the headphone output, which uses the exact same pins! As you might expect, this
+causes terrible headphone noise, the character of which is controlled by the
+1Ah boost control. (If you've seen instructions online to fix XPS 13 headphone
+noise by changing "Headphone Mic Boost" in ALSA, now you know why.)
+
+The information here has been obtained through black-box reverse engineering of
+the ALC256 codec's behavior and is not guaranteed to be correct. It likely
+also applies for the ALC255, ALC257, ALC235, and ALC236, since those codecs
+seem to be close relatives of the ALC256. (They all share one initialization
+function.) Additionally, other codecs like the ALC225 and ALC285 also have this
+register, judging by existing fixups in ``patch_realtek.c``, but specific
+data (e.g. node IDs, bit positions, pin mappings) for those codecs may differ
+from what I've described here.
-- 
2.25.2

