Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0DFA7ED35
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 09:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388083AbfHBHMW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 03:12:22 -0400
Received: from gwu.lbox.cz ([62.245.111.132]:40828 "EHLO gwu.lbox.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387657AbfHBHMW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 03:12:22 -0400
X-Greylist: delayed 614 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Aug 2019 03:12:21 EDT
Received: from linuxbox.linuxbox.cz (linuxbox.linuxbox.cz [10.76.66.10])
        by gwu.lbox.cz (Sendmail) with ESMTPS id x72721D9032737
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 2 Aug 2019 09:02:02 +0200
DKIM-Filter: OpenDKIM Filter v2.11.0 gwu.lbox.cz x72721D9032737
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxbox.cz;
        s=default; t=1564729322;
        bh=C5NZMYaiv4veWA0/ujjtthxC1ims9AQV3f4qdHZPCUo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BXroEnpNCOhF3S7tAm8dwRTbJ8lJ8Vmjd8hhLuJ9j2hJsywZ7a9aqdHpVEK2Tijng
         ORD/41KqziodM3xKsGQug/EH4xb5xvvIiDMf7cqtm1sJBmc4rkUGhDvELJjRnaBkVv
         YBMtds9x6k4A+FcC7xUXa9G/yXpOD4yzb1VE6G88=
Received: from pcnci.linuxbox.cz (pcnci.linuxbox.cz [10.76.3.14])
        by linuxbox.linuxbox.cz (Sendmail) with ESMTPS id x72721PJ022881
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 2 Aug 2019 09:02:01 +0200
Received: from pcnci.linuxbox.cz (localhost [127.0.0.1])
        by pcnci.linuxbox.cz (8.15.2/8.15.2) with ESMTP id x72721Om028809;
        Fri, 2 Aug 2019 09:02:01 +0200
Date:   Fri, 2 Aug 2019 09:02:01 +0200
From:   Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To:     Jinpu Wang <jinpuwang@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "v3.14+, only the raid10 part" <stable@vger.kernel.org>,
        Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: Re: [stable-4.19 0/4] CVE-2019-3900 fixes
Message-ID: <20190802070201.GA18798@pcnci.linuxbox.cz>
References: <20190722130313.18562-1-jinpuwang@gmail.com>
 <20190722154239.GH1607@sasha-vm>
 <CAD9gYJ+xhujXEHVNAEB5EUO7vwkXuZeU-xf0+g049uk8ucP_tA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAD9gYJ+xhujXEHVNAEB5EUO7vwkXuZeU-xf0+g049uk8ucP_tA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.76.66.2
X-Scanned-By: MIMEDefang v2.84/SpamAssassin v3.004000 on lbxovapx.linuxbox.cz (nik)
X-Scanned-By: MIMEDefang 2.84 on 10.76.66.10
X-Antivirus: on lbxovapx.linuxbox.cz by F-Secure antivirus, database version 2019-08-01_07
X-Spam-Score: N/A (imported whitelist)
X-Milter-Copy-Status: O
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

just wanted to ask about the status of those? I'm testing patches on top
of 4.19.60, not sure about how can I test if the problem is fixed, but at
least nothing seems to be broken so far..

BR

nik




On Tue, Jul 23, 2019 at 11:59:16AM +0200, Jinpu Wang wrote:
> Sasha Levin <sashal@kernel.org> 于2019年7月22日周一 下午5:42写道：
> >
> > On Mon, Jul 22, 2019 at 03:03:09PM +0200, Jack Wang wrote:
> > >Hi, Greg, hi Sasha,
> > >
> > >I noticed the fixes for CVE-2019-3900 are only backported to 4.14.133+,
> > >but not to 4.19, also 5.1, fixes have been included in 5.2.
> > >
> > >So I backported to 4.19, only compiles fine, no functional tests.
> > >
> > >Please review, and consider to include in next release.
> >
> > Thanks Jack. It'll be great if someone can test it and confirm it fixes
> > the issue (and nothing else breaks).
> >
> Agree, thanks
> > --
> > Thanks,
> > Sasha
> 

-- 
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28.rijna 168, 709 00 Ostrava

tel.:   +420 591 166 214
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------
