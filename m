Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8C011584C
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 21:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbfLFUu3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 15:50:29 -0500
Received: from mail.kapsi.fi ([91.232.154.25]:47563 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726330AbfLFUu3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Dec 2019 15:50:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=kapsi.fi;
         s=20161220; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ss6UfLsoQmlcXA1yqDJIpAvJTqCrLBwtxtjz5VAGhuQ=; b=R+dtclcHRqeov4Dce1CQnJ7hJM
        759RwUrjteFz+C/iud8n8WNcHrFmOzlFtcRcdVfZex3QqnAVio+yYaEsGLNDrqjNmuiUJLj8AShGT
        F8Wk7bztimAtWvqV8R4uNA6hO795Spj+7alT0yhYzhu8A9hflbH/r/no7IMrO2i1ob+v9WO/gcNbs
        kw1I0d+n06BGfLrGqJI4FIaU7uYEoPo23OPfuQSlyp9LGJRxMo2Moyi1y4vM8bzyjgxrmwfdc0Skr
        Mvry3gUnqUJyZNglmfm5w7w4f8WS5r2RfcVj0ez6lNcoRi41QrAmHTiwsG3ut84LcCL0UYXT87QIE
        28rEDEsw==;
Received: from 91-154-92-5.elisa-laajakaista.fi ([91.154.92.5] helo=localhost)
        by mail.kapsi.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <jarkko.sakkinen@linux.intel.com>)
        id 1idKYO-0002PB-SQ; Fri, 06 Dec 2019 22:50:20 +0200
Date:   Fri, 6 Dec 2019 22:50:20 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Dan Williams <dan.j.williams@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-integrity@vger.kernel.org, James Morris <jmorris@namei.org>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [GIT PULL] tpmdd updates for Linux v5.4
Message-ID: <20191206205020.GB9971@linux.intel.com>
References: <20190902143121.pjnykevzlajlcrh6@linux.intel.com>
 <CAA9_cmeLnHK4y+usQaWo72nUG3RNsripuZnS-koY4XTRC+mwJA@mail.gmail.com>
 <20191122161836.ry3cbon2iy22ftoc@cantor>
 <20191129210400.GB12055@linux.intel.com>
 <20191129232249.bgj25rlwrcg3afj5@cantor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191129232249.bgj25rlwrcg3afj5@cantor>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 91.154.92.5
X-SA-Exim-Mail-From: jarkko.sakkinen@linux.intel.com
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 29, 2019 at 04:22:49PM -0700, Jerry Snitselaar wrote:
> I still don't have access to one of the laptops, but looking online
> they should have one of the following: i5-8265U, i5-8365U, i7-8565U,
> or i7-8665U. The tpm is discrete, so I don't know that the cpu will
> matter. Looking at a log, in the t490s case it is an STMicroelectronics
> chip. So both Infineon and STM so far.

Still also seeking a local system.

/Jarkko
