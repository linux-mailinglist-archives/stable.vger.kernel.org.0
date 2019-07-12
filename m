Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80DB766A0A
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 11:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbfGLJhr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 05:37:47 -0400
Received: from sonic302-20.consmr.mail.ir2.yahoo.com ([87.248.110.83]:46431
        "EHLO sonic302-20.consmr.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725989AbfGLJhq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 05:37:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1562924264; bh=BeUU9nh43u+ACQyPCCh+HgVxrPdwY+ZLujvGntiisZ8=; h=Date:From:Reply-To:Subject:From:Subject; b=qJHwpJotZC6QshI7TlTrVBJUzRPZN5FGxtYkxnD0P2s8K5kJwnPad9uqGVIvHjTEteGdxyj+Di6UCqY/EsYMFTTaA2WJIlPMcDLRvMIJSopsiZxiINxdYLKS8HLYA5/Hh7j9Jn8E6pfVk+pLXfDrL7wC2iU6ppOK+kb3GSh8ij7MerXIvH+iQMn6HCd/+CAEhZcBy+DRoD2MXFUPzNzXEuYTBOCDdxY7jnv+5DGzZu7cdzxiYf2GXioPVDJQNnTiWA/ser9Mdrl5aNU2efIwLneVhNxHCNT9ZK38rmSAx+xJiVUylLi4Sxcf4FX4IhCP94i8G26Ilf37VcT/hLbELQ==
X-YMail-OSG: _1yLvj8VM1lnOuLlD5KGx.FS5MfoDALBlafKkaPB3VmarX5nCFHj7wPziFDuN7F
 lMl3oq9EBI.hazfmlltV8UDvD_XEDsoyetQO0cxNZlI.251P2Ou22_QJzNdEc8jP5uNv1kLh9u0i
 0Bwf8PRFowxsmtkpMSJJckPhez_YzWI6Ty01OlxzZe8ddGJN2urU70odkXVlIg11jqX.Gs_ioE36
 Hr70zJO5bzTgvBWXRAZMf7kF5vJWf0A7BdNTcegdd1PsihR5OVm_GHd0yvu9mEMB0j_AC5.m0dJI
 cbktYGwXgcT76XNNCm4gAdVDuCI1ocjVQePARYhLbdpN87kxanq80OMttWnY4czGbkqaYpIzO99p
 n8R.uowrwFpsD2clh_MHrbupM93nZpUaxCP6PeqUE5Vb54eDIoQlglqE11nUhRazN9MAnf_06XC1
 lDnj0SJqNIT9Nu_d6mlfXQnzaG_dFuwLf1m1haVhLvk_xa5oqpa29MXQUvMWhYtpFaVBnGFdAgVA
 6R6MX5ophrATL5qLozloB4AMIeUukSB2OIqMr5oMAbsYUQ8jOsA1OGy_lzgKV2_Hn3H_yiPSulJW
 g0_rGMvclWuNzuOD8JgV5P6vV9ofskIFEmO0Z330c4P6VN4ntyo4pVOmTVwnIIya122bYLWN6zDe
 slqKNTjK4zx0eQ_m3dkNJ8FTsDBY96NHcnRVyR3c_6dPxKUzeLLzmZMme2VyZL.7wdR8wFOks_.9
 eKP8xa2f4o__WjHE025B3NZLMtfqEMFiC93p1VriDBob5ps4jCApp1MNimRuO1S9prm4miFoeTVh
 dGrEqrYM0ab2qUsg_sCsUiK4kajfQvB3HsE1H5crirXi1IDUh.wK7n01vz6OWOMw9Lx4v9Ce0ggb
 gXct3sm0AxhfJjMMJFaHfRpVaSrWfglxV3JLtZVtROpakIQW_ETRbJBjsAtIZ6xAesehbyIr8xzI
 GgpWM7RDsAeDFO.s8NBSvdaBPzs2KNIQ3pddu1M1OWIOCLDdIIb_ImfaoWtQZtw3SgEu2Y0pAy36
 E09l3Muh3.0OtNfZ0hCaOEX81OUCvZJNHr3cE49v5CTM29OYzUfSPzwwcCtNh7CZInu9T0MG.YNG
 F_RDIobBxKf0ryx1SLHFEQ2DFzr5aFc_I_WMq4ejEzKx1tRoWlZfy5A4ChcPIaU8GB_dF0DFMb0h
 R.mj_8p7vpsI6SGcQTW5YqQS.GPUlcr2gmx.6X_HTv51J9VheJuaBPGk03.EWxJS8
Received: from sonic.gate.mail.ne1.yahoo.com by sonic302.consmr.mail.ir2.yahoo.com with HTTP; Fri, 12 Jul 2019 09:37:44 +0000
Date:   Fri, 12 Jul 2019 09:37:42 +0000 (UTC)
From:   Wilson Smith <smithwil456@gmail.com>
Reply-To: smithwil456@gmail.com
Message-ID: <47851498.202837.1562924262995@mail.yahoo.com>
Subject: HELLO! PLEASE TRY AND RESPOND SOONEST
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

My Dear Friend,

Before I introduce myself, I wish to inform you that this letter is not a h=
oax mail and I urge you to treat it serious. This letter must come to you a=
s a big surprise, but I believe it is only a day that people meet and becom=
e great friends and business partners. Please I want you to read this lette=
r very carefully and I must apologize for barging this message into your ma=
ilbox without any formal introduction due to the urgency and confidentialit=
y of this business and I know that this message will come to you as a surpr=
ise. Please this is not a joke and I will not like you to joke with it ok, =
with due respect to your person and much sincerity of purpose, I make this =
contact with you as I believe that you can be of great assistance to me. My=
 name is Mr.Wilson Smith, from London, UK. I work in Kas Bank UK branch as =
telex manager, please see this as a confidential message and do not reveal =
it to another person and let me know whether you can be of assistance regar=
ding my proposal below because it is top secret.

I am about to retire from active Banking service to start a new life but I =
am sceptical to reveal this particular secret to a stranger. You must assur=
e me that everything will be handled confidentially because we are not goin=
g to suffer again in life. It has been 10 years now that most of the greedy=
 African Politicians used our bank to launder money overseas through the he=
lp of their Political advisers. Most of the funds which they transferred ou=
t of the shores of Africa were gold and oil money that was supposed to have=
 been used to develop the continent. Their Political advisers always inflat=
ed the amounts before transferring to foreign accounts, so I also used the =
opportunity to divert part of the funds hence I am aware that there is no o=
fficial trace of how much was transferred as all the accounts used for such=
 transfers were being closed after transfer. I acted as the Bank Officer to=
 most of the politicians and when I discovered that they were using me to s=
ucceed in their greedy act; I also cleaned some of their banking records fr=
om the Bank files and no one cared to ask me because the money was too much=
 for them to control. They laundered over =C2=A35billion pounds during the =
process.

Before I send this message to you, I have already diverted (=C2=A33.5millio=
n pounds) to an escrow account belonging to no one in the bank. The bank is=
 anxious now to know who the beneficiary to the funds is because they have =
made a lot of profits with the funds. It is more than Eight years now and m=
ost of the politicians are no longer using our bank to transfer funds overs=
eas. The (=C2=A33.5million pounds) has been laying waste in our bank and I =
don=E2=80=99t want to retire from the bank without transferring the funds t=
o a foreign account to enable me to share the proceeds with the receiver (a=
 foreigner). The money will be shared 60% for me and 40% for you. There is =
no one coming to ask you about the funds because I secured everything. I on=
ly want you to assist me by providing a reliable bank account where the fun=
ds can be transferred. Make Sure You Reply To My private email: wilsnl74@gm=
ail.com
