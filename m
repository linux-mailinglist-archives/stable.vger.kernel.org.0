Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A18002236EB
	for <lists+stable@lfdr.de>; Fri, 17 Jul 2020 10:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726113AbgGQIVZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jul 2020 04:21:25 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:59191 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726056AbgGQIVZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jul 2020 04:21:25 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 51737AB7;
        Fri, 17 Jul 2020 04:21:24 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 17 Jul 2020 04:21:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=Fd7ulc5lJ7BN7KhqtmCodaF9lBt
        21K/QsVL/XYpcvLI=; b=GxCbRO2RCbjNaryCP/0Yu6R+uka2dj3LTDz/7Oh+gsx
        xuifBuggLtYtqG07KLxvp+81FdWcvvDuha7Yu3KEnEFGEVf0/8/nJmD2/csVAeXA
        051kyPBOkvjO1b7sKhp6F0ntpW7ubzWtkf/46h2cKlORQD51OmKWH2Kqb7/2uJej
        MADq0CEJHQtHEJW2q+Imq1PK8XvwFINfzdNbgZIIlCThaOQMdWzbL7T8XqcAjND9
        axOx8ETmIUQXNWuxptyIlwJYKIF7xHtEgvWWOKIZFVN4rWD8WykPI9mlDnu5ZiF1
        GLlHbUkBRHQ8T//ypI6MKLlJmNeuk5APsLsdFNJuo1Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Fd7ulc
        5lJ7BN7KhqtmCodaF9lBt21K/QsVL/XYpcvLI=; b=lrRWGpLAzw3WI/U81UDM2G
        3EizPHU0kf/JLT6NCDomCDoH7oNZ0azfxefjKoPBB3+6arETDroXBVf2K8VsY0aq
        EVc6nbVgYOZOTSoiMjZp7//qRQtzKFnCO0jqXwwa0AwBdu+inHdDhyIJ5vNDWRvO
        P9ceKiRuiUDWcIrMjHGLBbnrRUTHryjyAY5GdiPZR2ibMXgCr078zzQYICninCfp
        hG0xJmWBAVk1v09UtSLmBr26kC+zUEyVbGE6LMHd7O8T8h96uzq0xMMa715jwwB3
        fG1Ngazz8uUA8qAFv7US7UIwX2S4tljmw1xmNnwk9GQKizlfzHLVrkeguMlgA22g
        ==
X-ME-Sender: <xms:g18RXywXy2mHkjKOzxx_66CYtySA71OpgHnQX8VPzE_KI3TP7WJnzw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrfeehgddufedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:g18RX-SB0E41sEe_GWnlTU2kFAVk5t7c0omSJ195QOIuIyUdF7TZGg>
    <xmx:g18RX0V-ClFI2Ews5w201soENYkZhZwqT_YSlfInBWeYAQFeuh0Uag>
    <xmx:g18RX4gtaXEgFu19qnyQ-_lxDTOHCi9suM3yl_OGsFPNnwKijO66EQ>
    <xmx:g18RX3O7PgCOpZmX5WtO139XvX-yXG4xsPtDRJ-hhMVJx1R4wmjmZw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5A85730600A6;
        Fri, 17 Jul 2020 04:21:23 -0400 (EDT)
Date:   Fri, 17 Jul 2020 10:21:16 +0200
From:   Greg KH <greg@kroah.com>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20200717082116.GA1168425@kroah.com>
References: <20200716.160720.2007825724071053507.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716.160720.2007825724071053507.davem@davemloft.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 16, 2020 at 04:07:20PM -0700, David Miller wrote:
> 
> Please queue up the following networking bug fixes for v5.4 and
> v5.7 -stable, respectively.

All now queued up, thanks!

greg k-h
