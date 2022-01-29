Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1003E4A31C1
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 21:08:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346319AbiA2UIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 15:08:54 -0500
Received: from titan58.planetwebservers.net ([51.79.1.102]:42837 "EHLO
        titan58.planetwebservers.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234289AbiA2UIv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 15:08:51 -0500
X-Greylist: delayed 3397 seconds by postgrey-1.27 at vger.kernel.org; Sat, 29 Jan 2022 15:08:51 EST
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lockie.ca;
        s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:
        References:In-Reply-To:Message-ID:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=yRpLqUtfG7XQWRG/lUTFzoEYN9sCpBabATSYJtgl0d8=; b=wmaN+jBM7Aj7jnCT4pSWtOuDBK
        3F9weGJXPuyZkCy1A7Tssb9RNs2ioE1vKKRvTHx7fFVPF21iBTiVIj3dKkEhYNIJw5csIWjr+DJun
        94agcPtf1JrZoWBqZyCk+ewhw8qpOmnUWD16bB+f14c8k7/1b8SGe0CzcA3gz4tIRn/WaznZfz5jm
        2DTnysUjfsmMmWiFEXvJkfC7da/sx573yl21myvmGb1WQtJpkSiyiitSVc+jvardae1FuXf9+Wf31
        KqESnbfwvI5qxsTdM7cpVpvTM/F95VnQHhHjrmt+TFz8ZGBrY0tMcqk2oZNU2d9vVphi+3Ko8EN11
        M3Imp9rg==;
Received: from [37.19.213.223] (port=46210 helo=dummy.faircode.eu)
        by titan.planetwebservers.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <bjlockie@lockie.ca>)
        id 1nDt8v-00069r-1n; Sun, 30 Jan 2022 06:12:13 +1100
Date:   Sat, 29 Jan 2022 19:12:11 +0000 (UTC)
From:   James <bjlockie@lockie.ca>
To:     Felipe Contreras <felipe.contreras@gmail.com>
Cc:     Linux stable <stable@vger.kernel.org>,
        Linux wireless <linux-wireless@vger.kernel.org>
Message-ID: <cabdd567-6b8a-476b-ac45-e6ee170247f9@lockie.ca>
In-Reply-To: <CAMP44s2vAmfHU+h5bSp5FJvks7T+b_tpdU1U4pBvK9jFF6C=eQ@mail.gmail.com>
References:  <CAMP44s2vAmfHU+h5bSp5FJvks7T+b_tpdU1U4pBvK9jFF6C=eQ@mail.gmail.com>
Subject: Re: Regression in 5.16.3 with mt7921e
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Correlation-ID: <cabdd567-6b8a-476b-ac45-e6ee170247f9@lockie.ca>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - titan.planetwebservers.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - lockie.ca
X-Get-Message-Sender-Via: titan.planetwebservers.net: authenticated_id: bjlockie@lockie.ca
X-Authenticated-Sender: titan.planetwebservers.net: bjlockie@lockie.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-From-Rewrite: unmodified, already matched
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Does dmesg show anything?
