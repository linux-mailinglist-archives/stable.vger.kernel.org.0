Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE0F6E8A8E
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 08:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232922AbjDTGkq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 02:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232606AbjDTGkp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 02:40:45 -0400
X-Greylist: delayed 21111 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 19 Apr 2023 23:40:43 PDT
Received: from mail.heimpalkorhaz.hu (mail.heimpalkorhaz.hu [193.224.51.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93DAC9F
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 23:40:43 -0700 (PDT)
Received: from mail.heimpalkorhaz.hu (localhost [127.0.0.1])
        (Authenticated sender: lmateisz@heimpalkorhaz.hu)
        by mail.heimpalkorhaz.hu (Postfix) with ESMTPA id 47906384A4D089;
        Thu, 20 Apr 2023 01:44:42 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.heimpalkorhaz.hu 47906384A4D089
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heimpalkorhaz.hu;
        s=default; t=1681947882;
        bh=SFPaiUyYqM5Iz1wf9UVYSHssSttYIu6SPYgIrz5naIQ=;
        h=Date:From:To:Subject:Reply-To:From;
        b=hqD/vV28Nq5uNNynOV7vCeN9qXfMaH7M7uBRTUf4phQYmtIQAJ9pXdotJbEC0Hogm
         RRP68sQqeVHAHHHkqhaqyYO3kIXyQ4rAjXfZX1Ygn2J8kq1jVwUyRHmkrEya6c+YUI
         W10eS6vxYi85grQOTQgDfm77Y/WnZm9DYSDx2G4Ap3AtBXSmZ4/RUkWhfzA0rQwqZ4
         BeE3+q27z9L1tHYiml0lhzRs+/qzQsTGBMxHQpvt/1yBlQCvVf5YB+H2yZ/leVUHSr
         UkyxYmk3NLwkG+dYo4VU9Rj3bUqxOnaIpAOkuLr386M5XEA+N3Z6fBDioHh9BXChy7
         31ic9gi539mCQ==
MIME-Version: 1.0
Date:   Thu, 20 Apr 2023 07:44:42 +0800
From:   mk <mk@heimpalkorhaz.hu>
To:     undisclosed-recipients:;
Subject: Hej solsken
Reply-To: marionn.k99@gmail.com
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <e6ad5e80e23cdc37bf74325641d891ec@heimpalkorhaz.hu>
X-Sender: mk@heimpalkorhaz.hu
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [4.31 / 20.00];
        R_UNDISC_RCPT(3.00)[];
        FORGED_RECIPIENTS(2.00)[m:,s:sophie.lundmark@koping.se,s:sophie.tisell@friday.se,s:sophie@beyondactive.se,s:sophie@diabetsdestrole.info,s:sophie@equalityline.se,s:sophie@nordfasinvest.se,s:sophie@sparnet.se,s:sopwith@redhat.com,s:sorenalmkvist@gmail.com,s:soren.berggren@hotmail.com,s:soren.borgstrom@hammaro.se,s:soren.borgstrom@skola.hammaro.se,s:soren.borgstrom@skola.xn--hammar-1xa.se,s:soren.carnland@telia.com,s:soren.englund@byggnadsautomation.com,s:soreneson@gmail.com,s:soren.gustafsson@nvs.se,s:soren.hedlund@bredband.net,s:soren.hedlund@telia.com,s:soren.seehuusen@telia.com,s:soren.stenberg@tele2.se,s:sorenthunstrom@gmail.com,s:soren.wilhelmsson@bahnhof.se,s:soren@agergards.se,s:soren@sandahlsbolagen.se,s:sormlandslmk@gmail.com,s:sort@issara-resort.com,s:sos@sos.eu,s:sostenibilitat@torredembarra.cat,s:southfork@bahnhof.se,s:spaceinspections@gmail.com,s:spain22@bahnhof.se,s:spamproc@fbl.en25.com,s:spamtitan@bahnhof.net,s:spangerud@gmail.com,s:sparainvestera@nordea.com,s:sparris1
 14@gmail.com,s:sparvagnshallarna@sats.se,s:special_deal@free.autoterstin.com,s:specialsokarvikabhk@gmail.com,s:specialsok@kilsbhk.com,s:speedtel@spray.se,s:speigner@sk-lambach.at,s:sperre47@gmail.com,s:spettan8@hotmail.com,s:spf.linden@bahnhof.se,s:spfreftele@gmail.com,s:spf.villstad@bahnhof.se,s:spfseniorernahostsol@gmail.com,s:spfseniorernatimra@gmail.com,s:spicythai@bahnhof.se,s:spider@bahnhof.se,s:spinsign@bahnhof.se,s:spiran_53@yahoo.com,s:spl@bahnhof.se,s:splinter1958@hotmail.se,s:spoc-se@tele2.com,s:spordabo@gmail.com,s:sport@spolskytte.se,s:sportamore@footway.com,s:sportdirektor@dkbc.de,s:sporten@jp.se,s:sporten@nkp.se,s:sporten@nwt.se,s:sporten@vf.se,s:sportklubben@teamsportia.se,s:sportpalatset@sats.se,s:spotlight@ginatricot.com,s:sprend@sprend.com,s:sprottebo1@bahnhof.se,s:sprutandepenis@hotmail.com,s:spur@lipus.se,s:spurs66@live.se,s:sqe8l1.7e8ly.9z@bounce.sp247.net,s:srast@bioc.uzh.ch,s:srb@essem.se,s:srf.orebro.lan@telia.com,s:srrosander@hotmail.com,s:srwlundstedt@gmai
 l.com,s:srwebmail@utah.gov,s:ss@vnmb.hollandscheweekenddeals13.eu,s:ssaraolsson@hotmail.com,s:sschurman@ag-inc.com,s:sscmrjones@hotmail.com,s:sscu@tinet.cat,s:ssederlin@gmail.com,s:ssmg@scandinavian-songs.se,s:st.schuetz@outlook.com,s:staafjonas@hotmail.com,s:stable@vger.kernel.org,s:stacey.gomora@twolamp.icu,s:stacy-hartel@volac.icu,s:stacy.franzoni@upord.live,s:stadion@sats.se,s:stadium-info@collectorbank.se,s:stadium@collectorbank.se,s:stadium@email.mystadium.com,s:stadiummember@email.mystadium.com,s:stadiumoutlet@email.mystadium.com];
        GENERIC_REPUTATION(-0.59)[-0.58886633440012];
        MIME_GOOD(-0.10)[text/plain];
        TAGGED_RCPT(0.00)[];
        FROM_EQ_ENVFROM(0.00)[];
        RCVD_COUNT_ZERO(0.00)[0];
        MIME_TRACE(0.00)[0:+];
        FROM_HAS_DN(0.00)[];
        FREEMAIL_ENVRCPT(0.00)[gmail.com,hotmail.com,spray.se,yahoo.com,live.se,outlook.com,icloud.com,home.se,yahoo.se,me.com,hotmail.co.uk,consultant.com];
        TO_DN_ALL(0.00)[];
        MID_RHS_MATCH_FROM(0.00)[];
        RCPT_COUNT_ONE(0.00)[1];
        FREEMAIL_REPLYTO(0.00)[gmail.com];
        REPLYTO_DOM_NEQ_FROM_DOM(0.00)[];
        HAS_REPLYTO(0.00)[marionn.k99@gmail.com]
X-Rspamd-Queue-Id: 47906384A4D089
X-Rspamd-Server: mail.heimpalkorhaz.hu
X-Spam-Status: No, score=1.8 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_FORGED_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hej min kära,

Jag är ledsen att jag stör dig och inkräktar på din integritet. Jag är 
singel, ensam och i behov av en omtänksam, kärleksfull och romantisk 
följeslagare.

Jag är en hemlig beundrare och skulle vilja utforska möjligheten att 
lära mig mer om varandra. Jag vet att det är konstigt att kontakta dig 
på det här sättet och jag hoppas att du kan förlåta mig. Jag är en blyg 
person och det är det enda sättet jag vet att jag kan få din 
uppmärksamhet. Jag vill bara veta vad du tycker och min avsikt är inte 
att förolämpa dig. Jag hoppas att vi kan vara vänner om det är vad du 
vill, även om jag vill vara mer än bara en vän. Jag vet att du har några 
frågor att ställa och jag hoppas att jag kan tillfredsställa en del av 
din nyfikenhet med några svar.

Jag tror på talesättet att för världen är du bara en person, men för 
någon speciell är du världen, allt jag vill ha är kärlek, romantisk 
omsorg och uppmärksamhet från en speciell följeslagare som jag hoppas 
skulle vara du.

Jag hoppas att detta meddelande kommer att bli början på en långsiktig 
kommunikation mellan oss, skicka bara ett svar på detta meddelande, det 
kommer att göra mig glad.

Puss och kram,

Marion.
