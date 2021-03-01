Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F959329116
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243223AbhCAUS6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:18:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:39925 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242757AbhCAUMH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:12:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E567A64FB2;
        Mon,  1 Mar 2021 18:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621668;
        bh=sAIUE+D5y3VgxGQk7PQ5FFAUm5H9InRT/eqTH1+O7lo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SFdJCx9M9h3gPBHkwD/qybaEIVMAG+2p67BZOwBMYjCA4kpTFWYbkXuylMWSq02Sp
         bRPmlIdQFVx0br9ispDM1xOTnVN7efi2y0jA4xAcH3nPazSZAiS2rEfGR8rYVwLETN
         T3JHVDZfT32reHsfZOlc62L79bGg5BbUuuUsr1Yw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.11 593/775] ALSA: usb-audio: Correct document for snd_usb_endpoint_free_all()
Date:   Mon,  1 Mar 2021 17:12:41 +0100
Message-Id: <20210301161230.736650628@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 036f90dd92bb0aac66fdeec8386401dd396c6079 upstream.

The kerndoc comment for the new function snd_usb_endpoint_free_all()
had a typo wrt the argument name.  Fix it.

Fixes: 00272c61827e ("ALSA: usb-audio: Avoid unnecessary interface re-setup")
Reported-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210205082837.6327-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/endpoint.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -1451,7 +1451,7 @@ void snd_usb_endpoint_release(struct snd
 
 /**
  * snd_usb_endpoint_free_all: Free the resources of an snd_usb_endpoint
- * @card: The chip
+ * @chip: The chip
  *
  * This free all endpoints and those resources
  */


